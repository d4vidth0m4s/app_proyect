import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/esp32_data.dart';
import 'dart:convert';
import 'dart:async';

class BLEController extends ChangeNotifier {
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? txCharacteristic;
  BluetoothCharacteristic? rxCharacteristic;

  bool isConnected = false;
  bool isScanning = false;
  ESP32Data? lastData;
  int _savedTimeOn = 0;

  final String serviceUUID = "12345678-1234-5678-9abc-def123456789";
  final String txCharacteristicUUID = "87654321-4321-8765-cba9-fed987654321";
  final String rxCharacteristicUUID = "11111111-2222-3333-4444-555555555555";

  StreamSubscription<List<ScanResult>>? scanSubscription;
  StreamSubscription<List<int>>? characteristicSubscription;

  static const String _timeOnKey = 'last_time_on';

  BLEController() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadSavedTimeOn();
    initBLE();
  }

  Future<void> _loadSavedTimeOn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _savedTimeOn = prefs.getInt(_timeOnKey) ?? 0;
      print("TimeOn cargado desde almacenamiento: $_savedTimeOn ms");
    } catch (e) {
      print("Error al cargar timeOn: $e");
      _savedTimeOn = 0;
    }
  }

  Future<void> _saveTimeOn(int timeOn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_timeOnKey, timeOn);
      _savedTimeOn = timeOn;
      print("TimeOn guardado: $timeOn ms");
    } catch (e) {
      print("Error al guardar timeOn: $e");
    }
  }

  int getCurrentTimeOn() {
    final currentTimeOn = lastData?.timeon ?? 0;
    return isConnected ? currentTimeOn : _savedTimeOn;
  }

  Future<bool> requestPermissions() async {
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    return statuses.values.every(
      (status) => status.isGranted || status.isLimited,
    );
  }

  Future<bool> hasBlePermissions() async {
    final permissions = [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ];

    for (final permission in permissions) {
      final status = await permission.status;
      if (!status.isGranted && !status.isLimited) {
        return false;
      }
    }

    return true;
  }

  void initBLE() async {
    if (!await FlutterBluePlus.isSupported) {
      print("Bluetooth no soportado");
      return;
    }

    FlutterBluePlus.adapterState.listen((state) async {
      if (state != BluetoothAdapterState.on) {
        print("Bluetooth apagado");
      }
    });
  }

  void startScan() async {
    if (!await hasBlePermissions()) {
      print("Permisos BLE no concedidos");
      return;
    }

    FlutterBluePlus.adapterState.listen((state) async {
      if (state != BluetoothAdapterState.on) {
        print("Bluetooth apagado");
        await FlutterBluePlus.turnOn();
      }
    });

    if (isScanning) return;

    isScanning = true;
    notifyListeners();

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.platformName == "ESP32-Motor-Control") {
          print("ESP32 encontrado");
          FlutterBluePlus.stopScan();
          connectToDevice(result.device);
          break;
        }
      }
    });

    Timer(const Duration(seconds: 10), () {
      if (isScanning) {
        FlutterBluePlus.stopScan();
        isScanning = false;
        notifyListeners();
      }
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      connectedDevice = device;

      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _handleDisconnection();
        }
      });

      final services = await device.discoverServices();
      for (var service in services) {
        if (service.uuid.toString().toLowerCase() ==
            serviceUUID.toLowerCase()) {
          for (var characteristic in service.characteristics) {
            final uuid = characteristic.uuid.toString().toLowerCase();

            if (uuid == txCharacteristicUUID.toLowerCase()) {
              txCharacteristic = characteristic;
              await characteristic.setNotifyValue(true);
              characteristicSubscription = characteristic.lastValueStream
                  .listen(handleReceivedData);
            } else if (uuid == rxCharacteristicUUID.toLowerCase()) {
              rxCharacteristic = characteristic;
            }
          }
        }
      }

      isConnected = true;
      isScanning = false;
      notifyListeners();
      print("Conectado al ESP32");
    } catch (e) {
      print("Error al conectar: $e");
      isScanning = false;
      notifyListeners();
    }
  }

  void handleReceivedData(List<int> data) {
    try {
      final jsonString = utf8.decode(data);
      final jsonData = json.decode(jsonString);
      lastData = ESP32Data.fromJson(jsonData);

      if (lastData?.timeon != null) {
        _saveTimeOn(lastData!.timeon);
      }

      notifyListeners();
      print("Datos recibidos: $jsonString");
    } catch (e) {
      print("Error al decodificar datos: $e");
    }
  }

  void _handleDisconnection() {
    print("Desconectado del ESP32");
    if (lastData?.timeon != null) {
      _saveTimeOn(lastData!.timeon);
    }

    connectedDevice = null;
    txCharacteristic = null;
    rxCharacteristic = null;
    isConnected = false;
    notifyListeners();
  }

  void sendCommand(String estado, {bool apagadoEmergencia = false}) async {
    if (!isConnected || rxCharacteristic == null) {
      print("No conectado");
      return;
    }

    final command = {
      "estado": estado,
      "apagadodeemergencia": apagadoEmergencia,
    };

    final jsonString = json.encode(command);
    final bytes = utf8.encode(jsonString);

    try {
      await rxCharacteristic!.write(bytes);
      print("Comando enviado: $jsonString");
    } catch (e) {
      print("Error al enviar comando: $e");
    }
  }

  void disconnect() async {
    if (lastData?.timeon != null) {
      await _saveTimeOn(lastData!.timeon);
    }

    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
      txCharacteristic = null;
      rxCharacteristic = null;
      lastData = null;
      isConnected = false;
      notifyListeners();
    }
  }

  Future<void> clearSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_timeOnKey);
      _savedTimeOn = 0;
      print("Datos guardados limpiados");
    } catch (e) {
      print("Error al limpiar datos: $e");
    }
  }

  @override
  void dispose() {
    if (lastData?.timeon != null) {
      _saveTimeOn(lastData!.timeon);
    }

    scanSubscription?.cancel();
    characteristicSubscription?.cancel();
    disconnect();
    super.dispose();
  }
}
