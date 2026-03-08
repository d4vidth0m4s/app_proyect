import 'package:app_proyect/providers/alert_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyect/data/ble/ble_controller.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final ScrollController _scrollController = ScrollController();
  int _previousAlertCount = 0;
  AlertProvider? _alertProvider; // Referencia guardada para dispose seguro

  @override
  void initState() {
    super.initState();
    // Inicializar el listener para el autoscroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupAutoScroll();
    });
  }

  void _setupAutoScroll() {
    _alertProvider = context.read<AlertProvider>();
    _alertProvider?.addListener(_onAlertsChanged);
  }

  void _onAlertsChanged() {
    if (!mounted) return; // Verificar si el widget sigue montado

    final currentAlertCount = _alertProvider?.alerts.length ?? 0;

    // Solo hacer scroll si hay nuevas alertas
    if (currentAlertCount > _previousAlertCount) {
      _scrollToBottom();
      _previousAlertCount = currentAlertCount;
    }
  }

  void _scrollToBottom() {
    if (!mounted || !_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _processAlerts();
  }

  void _processAlerts() {
    final ble = context.watch<BLEController>();
    final alertProvider = context.read<AlertProvider>();
    final alertBits = _extractAlertBits(ble);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      alertProvider.processAlertBits(alertBits);
    });
  }

  int _extractAlertBits(BLEController ble) {
    if (!ble.isConnected || ble.lastData == null) {
      return 0;
    }
    return ble.lastData!.alertas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildAlertList());
  }

  Widget _buildAlertList() {
    return Consumer<AlertProvider>(
      builder: (context, alertProvider, child) {
        final alerts = alertProvider.alerts;

        if (alerts.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          itemCount: alerts.length,
          itemBuilder: (context, index) =>
              _buildAlertItem(alerts[index], index),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No hay alertas',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(alert, int index) {
    final timeString = _formatTime(alert.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.warning_amber,
          color: Colors.orange,
          size: 20,
        ),
        title: Text(alert.text, style: const TextStyle(fontSize: 15)),
        subtitle: Text(
          timeString,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return "$hour:$minute:$second";
  }

  @override
  void dispose() {
    // Limpiar el listener usando la referencia guardada
    _alertProvider?.removeListener(_onAlertsChanged);
    _scrollController.dispose();
    super.dispose();
  }
}
