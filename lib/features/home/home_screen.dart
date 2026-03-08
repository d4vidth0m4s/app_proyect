import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:app_proyect/models/layout_box.dart';
import 'package:app_proyect/core/utils/calculate_layout_values.dart';
import 'package:app_proyect/shared/widgets/decoration.dart';
import 'package:flutter/material.dart';
import 'package:app_proyect/shared/widgets/info_card.dart';
import 'package:provider/provider.dart';
import 'package:app_proyect/data/ble/ble_controller.dart';
import '../config/config_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print("query: ${screenSize}");

    final layoutValues = calculateLayoutValues(screenSize);
    final ble = context.watch<BLEController>();
    final reValues = relativeValues(
      x: screenSize.width * 0.4,
      y: screenSize.height * 1.05,
      angle: -170.284 * (3.14159 / 180),
      width: 1.21,
      height: 1.26,
      color: AppColors.secondary,
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo decorativo (atrÃ¡s)
            buildDecoration(layoutValues, null, reValues, 2),

            // Contenido principal (al frente)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildBottomRow(context, ble, screenSize),
                  const SizedBox(height: 5),
                  _buildTopRow(screenSize, ble),
                  const SizedBox(height: 5),
                  _buildMiddleRow(screenSize, ble),
                  const SizedBox(height: 5),
                  _buildBottomRow2(screenSize, ble),

                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(Size screenSize, BLEController ble) {
    return Row(
      children: [
        Expanded(child: _buildMotorCard(screenSize, ble)),
        Expanded(child: _buildOperationCard(ble, screenSize)),
      ],
    );
  }

  Widget _buildMiddleRow(Size screenSize, BLEController ble) {
    return Row(
      children: [
        Expanded(child: _buildTemperatureCard(ble, screenSize)),
        Expanded(child: _buildSpeedCard(ble, screenSize)),
      ],
    );
  }

  Widget _buildBottomRow(
    BuildContext context,
    BLEController ble,
    Size screenSize,
  ) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _handleConnectionCardTap(context, ble),
            child: _buildStatusCard(ble, screenSize),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow2(Size screenSize, BLEController ble) {
    return Row(children: [Expanded(child: _buildStatusCard2(ble, screenSize))]);
  }

  Widget _buildMotorCard(Size screenSize, BLEController ble) {
    return InfoCard(
      title: 'Motr',
      icon: Icons.electric_bolt_outlined,
      height: screenSize.height * 0.2, // Ya estaba en porcentaje
      child: MiIndicadorCircular(
        porcentaje: _calculateMotorPercentage(ble.lastData?.corriente),
      ),
    );
  }

  Widget _buildOperationCard(BLEController ble, Size screenSize) {
    return InfoCard(
      title: 'Operacion',
      icon: Icons.timer,
      height: screenSize.height * 0.2, // Cambio de 180 a 22% de la altura
      child: buildStyledValueText(text: _formatTime(ble.getCurrentTimeOn())),
    );
  }

  Widget _buildTemperatureCard(BLEController ble, Size screenSize) {
    return InfoCard(
      title: 'Temperatura',
      icon: Icons.thermostat_outlined,
      height: screenSize.height * 0.2, // Cambio de 180 a 22% de la altura
      child: buildStyledValueText(text: _getTemperatureText(ble)),
    );
  }

  Widget _buildSpeedCard(BLEController ble, Size screenSize) {
    return InfoCard(
      title: 'Velocidad',
      icon: Icons.speed,
      height: screenSize.height * 0.2, // Cambio de 180 a 22% de la altura
      child: MiIndicadorCircular(porcentaje: _calculateSpeedPercentage(ble)),
    );
  }

  Widget _buildStatusCard(BLEController ble, Size screenSize) {
    return InfoCard(
      title: 'Estado',
      icon: _getStatusIcon(ble),
      height: screenSize.height * 0.1,
      child: ontap(
        value: _getStatusText(ble),
        isStatus: !ble.isConnected,
        isStatusColor: ble.lastData?.estado ?? false,
        onTap: null,
      ),
    );
  }

  Widget _buildStatusCard2(BLEController ble, Size screenSize) {
    return InfoCard(
      title: 'Encendido/Apagado',
      icon: Icons.power,
      height: screenSize.height * 0.24,
      child: Container(
        alignment: Alignment.center,
        child: ontap2(
          isStatus: !ble.isConnected,
          isStatusColor: ble.lastData?.estado ?? true,
          onTap: () => _handleStatusTap(ble),
        ),
      ),
    );
  }

  // MÃ©todos de utilidad privados
  String _formatTime(int millis) {
    final duration = Duration(milliseconds: millis);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  double _calculateMotorPercentage(double? corriente) {
    return ((corriente ?? 0) / 10.0).clamp(0.0, 1.0);
  }

  String _getTemperatureText(BLEController ble) {
    return ble.isConnected ? '${ble.lastData?.temperatura}Â°C' : "Â°C";
  }

  double _calculateSpeedPercentage(BLEController ble) {
    if (!ble.isConnected) return 0.0;
    return ((ble.lastData?.rpm ?? 0) / 3000).toDouble().clamp(0.0, 1.0);
  }

  IconData _getStatusIcon(BLEController ble) {
    return ble.isConnected
        ? Icons.bluetooth_connected_rounded
        : Icons.bluetooth;
  }

  String _getStatusText(BLEController ble) {
    if (!ble.isConnected) return 'Desconectado';
    return (ble.lastData?.estado ?? false) ? 'Encendido' : 'Apagado';
  }

  Future<void> _handleConnectionCardTap(
    BuildContext context,
    BLEController ble,
  ) async {
    final granted = await ble.requestPermissions();
    if (!context.mounted) return;

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes conceder permisos de Bluetooth para conectar el ESP32.',
          ),
        ),
      );
      return;
    }

    showConfigBottomSheet(context);
  }

  void _handleStatusTap(BLEController ble) {
    if (ble.isConnected && ble.lastData != null) {
      final command = ble.lastData!.estado ? "apagar" : "encender";
      ble.sendCommand(command);
    }
  }
}
