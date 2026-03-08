import 'package:app_proyect/providers/time_record_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyect/data/ble/ble_controller.dart';

class AppLifecycleWrapper extends StatefulWidget {
  final Widget child;

  const AppLifecycleWrapper({super.key, required this.child});

  @override
  State<AppLifecycleWrapper> createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends State<AppLifecycleWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final ble = context.read<BLEController>();

    switch (state) {
      case AppLifecycleState.paused:
        print("ðŸ“± App pausada - guardando datos...");
        _saveCurrentData(ble);
        break;
      case AppLifecycleState.detached:
        print("ðŸ“± App cerrada - guardando datos...");
        _saveCurrentData(ble);
        break;
      case AppLifecycleState.resumed:
        print("ðŸ“± App reanudada");
        break;
      case AppLifecycleState.inactive:
        print("ðŸ“± App inactiva");
        break;
      case AppLifecycleState.hidden:
        print("ðŸ“± App oculta");
        break;
    }
  }

  Future<void> _saveCurrentData(BLEController ble) async {
    if (ble.lastData?.timeon != null) {
      // Forzar guardado inmediato
      ble.getCurrentTimeOn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
