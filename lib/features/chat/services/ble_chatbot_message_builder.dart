import 'package:app_proyect/models/esp32_data.dart';

class BleChatbotMessageBuilder {
  const BleChatbotMessageBuilder._();

  static String build({
    required bool isConnected,
    required bool isScanning,
    required String? deviceName,
    required String? deviceId,
    required String? lastBleError,
    required ESP32Data? lastData,
    required int savedTimeOn,
    required String sensorSummary,
  }) {
    final buffer = StringBuffer()
      ..writeln(
        'Analiza el estado del sistema con todos los datos BLE disponibles y responde con un diagnostico breve.',
      )
      ..writeln('Conexion BLE: ${isConnected ? 'activa' : 'inactiva'}.')
      ..writeln('Escaneo BLE: ${isScanning ? 'en curso' : 'detenido'}.');

    if (deviceName != null && deviceName.trim().isNotEmpty) {
      buffer.writeln('Dispositivo: ${deviceName.trim()}.');
    }

    if (deviceId != null && deviceId.trim().isNotEmpty) {
      buffer.writeln('Device ID: ${deviceId.trim()}.');
    }

    if (lastBleError != null && lastBleError.trim().isNotEmpty) {
      buffer.writeln('Ultimo error BLE: ${lastBleError.trim()}.');
    }

    if (lastData != null) {
      buffer
        ..writeln('RPM actuales: ${lastData.rpm}.')
        ..writeln(
          'Corriente actual: ${lastData.corriente.toStringAsFixed(2)} A.',
        )
        ..writeln(
          'Temperatura actual: ${lastData.temperatura.toStringAsFixed(2)} C.',
        )
        ..writeln('Tiempo encendido actual: ${lastData.timeon} ms.')
        ..writeln(sensorSummary)
        ..writeln(
          'Indica si observas un riesgo, la causa probable y la accion recomendada.',
        );
    } else {
      buffer
        ..writeln('No hay un paquete BLE reciente disponible.')
        ..writeln('Ultimo tiempo encendido guardado: $savedTimeOn ms.');
    }

    return buffer.toString().trim();
  }
}
