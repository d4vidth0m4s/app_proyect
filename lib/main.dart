import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:app_proyect/core/theme/app_theme.dart';
import 'package:app_proyect/data/ble/ble_controller.dart';
import 'package:app_proyect/features/chat/chat_screen.dart';
import 'package:app_proyect/features/splash/splash_screen.dart';
import 'package:app_proyect/providers/alert_provider.dart';
import 'package:app_proyect/providers/time_record_helper.dart';
import 'package:app_proyect/shared/widgets/app_life_cycle_wrapper.dart';
import 'package:app_proyect/shared/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TimeRecordHelper.mostrarEstadisticas();

  /*
  await TimeRecordHelper.limpiarRegistros();

  await TimeRecordHelper.seedData();
  await ejemploDeUso();
*/

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BLEController()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

Future<void> ejemploDeUso() async {
  print('=== EJEMPLO DE USO ===');

  await TimeRecordHelper.registrarTiempo(1000000);
  await TimeRecordHelper.registrarTiempo(800000);
  await TimeRecordHelper.registrarTiempo(1200000);
  await TimeRecordHelper.mostrarEstadisticas();

  print('=== FIN DEL EJEMPLO ===\n');
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App con Bottom Navigation',
      theme: AppTheme.light,
      home: AppLifecycleWrapper(child: const SplashScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _builAppStack(context)));
  }

  Widget _builAppStack(BuildContext context) {
    return Stack(
      children: [
        const BottomNavigation(),
        Positioned(
          bottom: 110,
          right: 20,
          child: _buildFloatingButton(context),
        ),
      ],
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      focusNode: FocusNode(),
      backgroundColor: AppColors.secondaryVariant,
      child: AppIcons.user(start: false),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
      },
    );
  }
}
