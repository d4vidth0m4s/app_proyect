import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:app_proyect/data/ble/ble_controller.dart';
import 'package:app_proyect/shared/widgets/app_feedback_snackbar.dart';
import 'package:app_proyect/shared/widgets/qr_device_scanner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionSettingsScreen extends StatefulWidget {
  const ConnectionSettingsScreen({super.key});

  @override
  State<ConnectionSettingsScreen> createState() =>
      _ConnectionSettingsScreenState();
}

class _ConnectionSettingsScreenState extends State<ConnectionSettingsScreen> {
  late final TextEditingController _deviceNameController;
  late final TextEditingController _deviceIdController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final ble = context.read<BLEController>();
    _deviceNameController = TextEditingController(text: ble.deviceName);
    _deviceIdController = TextEditingController(text: ble.deviceId);
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _deviceIdController.dispose();
    super.dispose();
  }

  void _syncFields(BLEController ble) {
    if (_deviceNameController.text != ble.deviceName) {
      _deviceNameController.text = ble.deviceName;
    }
    if (_deviceIdController.text != ble.deviceId) {
      _deviceIdController.text = ble.deviceId;
    }
  }

  Future<void> _openQrScanner() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: QrDeviceScanner(
              title: 'Escanear QR',
              description:
                  'Carga automaticamente la configuracion BLE del dispositivo.',
              scannerHeight: 280,
              onConfigDetected: (config) async {
                await context.read<BLEController>().loadDeviceConfig(config);
                _deviceNameController.text =
                    config['deviceName']?.toString() ?? '';
                _deviceIdController.text = config['deviceId']?.toString() ?? '';

                if (!mounted) return;
                Navigator.of(modalContext).pop();
                AppFeedbackSnackBar.show(
                  context,
                  message: 'Configuracion cargada desde el QR.',
                  type: AppFeedbackType.success,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveConnectionConfig() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    await context.read<BLEController>().loadDeviceConfig({
      'deviceName': _deviceNameController.text,
      'deviceId': _deviceIdController.text,
    });

    if (!mounted) return;

    AppFeedbackSnackBar.show(
      context,
      message: 'Configuracion guardada correctamente.',
      type: AppFeedbackType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ble = context.watch<BLEController>();
    _syncFields(ble);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Conexion'),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Actual: ${ble.deviceName} | ${ble.deviceId}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openQrScanner,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Escanear QR'),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _deviceNameController,
                  decoration: const InputDecoration(
                    labelText: 'deviceName',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa un deviceName.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _deviceIdController,
                  decoration: const InputDecoration(
                    labelText: 'deviceId',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa un deviceId.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveConnectionConfig,
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
