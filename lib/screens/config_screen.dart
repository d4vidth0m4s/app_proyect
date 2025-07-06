// lib/widgets/config_bottom_sheet.dart
import 'package:app_proyect/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/servicie/ble_controller.dart';



class ConfigBottomSheet extends StatelessWidget {
  const ConfigBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ble = context.watch<BLEController>();

    return Column(
       mainAxisSize: MainAxisSize.min,
      children: [
        // Botón de cerrar (X)
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),  
        ),
       
        const SizedBox(height: 4),
        
        // Título
        const Text(
          "Conectate al Esp43",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        
        const SizedBox(height: 8),

        // Subtítulo
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Para conectar un dispositivo, asegúrese de que esté activado y en modo de emparejamiento.",
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
            color: ble.isConnected ?  Colors.green.shade200 : Colors.orange.shade200,
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
            image: AssetImage('assets/images/esp32_wroom_32e.webp'), // Asegúrate de agregarla en `pubspec.yaml`
            fit: BoxFit.cover,
    ),
          ),
        ),
        
        const SizedBox(height: 24),

      if (!ble.isConnected) Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ble.isScanning ? null : ble.startScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
                padding: const EdgeInsets.all(AppSizes.paddingin),
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
      
      else Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ble.disconnect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  padding: const EdgeInsets.all(AppSizes.paddingin),
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

    
      ]
      );
  }
}


void showConfigBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white.withOpacity(0.97),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: ConfigBottomSheet(),
            ),
          );
        },
      );
    },
  );
}
