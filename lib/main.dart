import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'helpers/time_record_helper.dart';
import 'models/time_record.dart';
import 'constants/app_constants.dart';
import 'widgets/bottom_navigation.dart';
import 'servicie/ble_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();



   await ejemploDeUso();

  runApp(
    ChangeNotifierProvider(
      create: (_) => BLEController(),
      child: const MainApp(),
    ),
  );
}



Future<void> ejemploDeUso() async {
  print('=== EJEMPLO DE USO ===');
  
  // Primera llamada del día
  await TimeRecordHelper.registrarTiempo(10000);
  
  // Segunda llamada del mismo día
  await TimeRecordHelper.registrarTiempo(8000);
  
  // Tercera llamada del mismo día  
  await TimeRecordHelper.registrarTiempo(12000);
  
  // Mostrar estadísticas
  await TimeRecordHelper.mostrarEstadisticas();
  
  // Obtener registro específico
  TimeRecord? registroHoy = await TimeRecordHelper.obtenerRegistroHoy();
  
  if (registroHoy != null) {
    print('Registro de hoy: ${registroHoy.toString()}');
  }
  
  print('=== FIN DEL EJEMPLO ===\n');
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App con Bottom Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const BottomNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
