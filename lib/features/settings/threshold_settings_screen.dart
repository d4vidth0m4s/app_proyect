import 'dart:convert';

import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:app_proyect/data/ble/ble_controller.dart';
import 'package:app_proyect/shared/widgets/app_feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThresholdSettingsScreen extends StatefulWidget {
  const ThresholdSettingsScreen({super.key});

  @override
  State<ThresholdSettingsScreen> createState() => _ThresholdSettingsScreenState();
}

class _ThresholdSettingsScreenState extends State<ThresholdSettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _iNominalController;
  late final TextEditingController _iUmbral1Controller;
  late final TextEditingController _iUmbral2Controller;
  late final TextEditingController _tMaxController;

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _iNominalController = TextEditingController(text: '2.0');
    _iUmbral1Controller = TextEditingController(text: '4.0');
    _iUmbral2Controller = TextEditingController(text: '5.5');
    _tMaxController = TextEditingController(text: '60.0');
  }

  @override
  void dispose() {
    _iNominalController.dispose();
    _iUmbral1Controller.dispose();
    _iUmbral2Controller.dispose();
    _tMaxController.dispose();
    super.dispose();
  }

  String? _validatePositiveFloat(String? value, {required String label}) {
    final normalized = value?.trim().replaceAll(',', '.');
    if (normalized == null || normalized.isEmpty) {
      return 'Ingresa $label.';
    }

    final parsed = double.tryParse(normalized);
    if (parsed == null) {
      return 'Ingresa un numero valido.';
    }

    if (parsed <= 0) {
      return 'Debe ser mayor que 0.';
    }

    return null;
  }

  double _parseController(TextEditingController controller) {
    return double.parse(controller.text.trim().replaceAll(',', '.'));
  }

  Future<void> _saveThresholds(BLEController ble) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!ble.isConnected) {
      AppFeedbackSnackBar.show(
        context,
        message: 'Conecta el ESP32 antes de guardar la configuracion.',
        type: AppFeedbackType.info,
      );
      return;
    }

    final iNominal = _parseController(_iNominalController);
    final iUmbral1 = _parseController(_iUmbral1Controller);
    final iUmbral2 = _parseController(_iUmbral2Controller);
    final tMax = _parseController(_tMaxController);

    if (iUmbral1 < iNominal) {
      AppFeedbackSnackBar.show(
        context,
        message: 'I_umbral1 debe ser mayor o igual a I_nominal.',
        type: AppFeedbackType.info,
      );
      return;
    }

    if (iUmbral2 < iUmbral1) {
      AppFeedbackSnackBar.show(
        context,
        message: 'I_umbral2 debe ser mayor o igual a I_umbral1.',
        type: AppFeedbackType.info,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSending = true);

    final payload = json.encode({
      'comando': 'config',
      'I_nominal': iNominal,
      'I_umbral1': iUmbral1,
      'I_umbral2': iUmbral2,
      'T_max': tMax,
    });

    final success = await ble.sendCommand(payload, isConfigCommand: true);

    if (!mounted) {
      return;
    }

    setState(() => _isSending = false);

    AppFeedbackSnackBar.show(
      context,
      message: success
          ? 'Configuracion enviada al ESP32.'
          : 'No se pudo enviar la configuracion al ESP32.',
      type: success ? AppFeedbackType.success : AppFeedbackType.error,
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String helper,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => _validatePositiveFloat(value, label: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BLEController>(
      builder: (context, ble, child) {
        final canSend = ble.isConnected && !_isSending;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Umbrales'),
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
                      ble.isConnected
                          ? 'Conexion activa con ${ble.deviceName} (${ble.deviceId}).'
                          : 'Conecta el ESP32 para guardar los umbrales en memoria persistente.',
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    _buildNumberField(
                      controller: _iNominalController,
                      label: 'I_nominal',
                      helper: 'Corriente nominal del sistema.',
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      controller: _iUmbral1Controller,
                      label: 'I_umbral1',
                      helper: 'Inicio de sobrecarga.',
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      controller: _iUmbral2Controller,
                      label: 'I_umbral2',
                      helper: 'Proteccion por corriente.',
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      controller: _tMaxController,
                      label: 'T_max',
                      helper: 'Temperatura maxima permitida.',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canSend ? () => _saveThresholds(ble) : null,
                        child: Text(
                          _isSending ? 'Enviando...' : 'Guardar en ESP32',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
