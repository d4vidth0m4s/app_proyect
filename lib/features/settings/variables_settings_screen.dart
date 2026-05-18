import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:app_proyect/shared/widgets/app_feedback_snackbar.dart';
import 'package:flutter/material.dart';

class VariablesSettingsScreen extends StatefulWidget {
  const VariablesSettingsScreen({super.key});

  @override
  State<VariablesSettingsScreen> createState() =>
      _VariablesSettingsScreenState();
}

class _VariablesSettingsScreenState extends State<VariablesSettingsScreen> {
  late final TextEditingController _temperatureController;
  late final TextEditingController _currentController;

  @override
  void initState() {
    super.initState();
    _temperatureController = TextEditingController();
    _currentController = TextEditingController();
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    _currentController.dispose();
    super.dispose();
  }

  void _printVariables() {
    final temperature = _temperatureController.text.trim();
    final current = _currentController.text.trim();

    print('Variables de control por histeresis:');
    print('Temperatura: $temperature');
    print('Corriente: $current');

    AppFeedbackSnackBar.show(
      context,
      message: 'Variables enviadas al log.',
      type: AppFeedbackType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Variables'),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configura las variables que determinaran el control por histeresis.',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _temperatureController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Temperatura',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Corriente',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _printVariables,
                  child: const Text('Probar variables'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
