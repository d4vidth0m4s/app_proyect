// lib/widgets/config_bottom_sheet.dart
import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:app_proyect/shared/widgets/show_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyect/data/ble/ble_controller.dart';

class ConfigBottomSheet extends StatelessWidget {
  const ConfigBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ble = context.watch<BLEController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),

        // SubtÃ­tulo
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Para conectar un dispositivo, asegurate de que el ESP32 este activado y en modo de emparejamiento.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 24),

        // Caja naranja de contenido
        Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: ble.isConnected
                ? Colors.green.shade200
                : Colors.orange.shade200,
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(
                'assets/images/esp32_wroom_32e.webp',
              ), // AsegÃºrate de agregarla en `pubspec.yaml`
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 24),

        if (!ble.isConnected && ble.lastBleError != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              ble.lastBleError!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        if (!ble.isConnected && ble.lastBleError != null)
          const SizedBox(height: 12),

        if (!ble.isConnected)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ble.isScanning ? null : ble.startScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0, // opcional: sin sombra
                ),
                child: Text(
                  ble.isScanning ? 'Buscando...' : 'Buscar ESP32',
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ble.disconnect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0, // opcional: sin sombra
                ),
                child: const Text(
                  'Desconectar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

//  context: context,
//  child: ConfigBottomSheet(),
//  initialChildSize: 0.6,
void showConfigBottomSheet(BuildContext context) {
  CustomBottomSheet.show(
    onConfirm: () => Navigator.pop(context),
    title: 'Conertar ESP32',
    context: context,
    initialChildSize: 0.6,

    child: const ConfigBottomSheet(),
  );
}
