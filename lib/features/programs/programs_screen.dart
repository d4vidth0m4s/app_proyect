import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:app_proyect/models/semana_data.dart';
import 'package:app_proyect/data/ble/ble_controller.dart';
import 'package:app_proyect/shared/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_proyect/models/time_record.dart';
import 'package:app_proyect/providers/time_record_helper.dart';
import 'package:app_proyect/core/utils/time_records_utils.dart';
import 'package:app_proyect/shared/widgets/picker_item.dart';
import 'package:app_proyect/shared/widgets/weekly_bar_chart.dart';
import 'package:app_proyect/shared/widgets/show_modal_bottom_sheet.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  int indiceSeleccionado = 0;
  List<TimeRecord> _registros = [];
  List<SemanaData> _semanas = [];

  @override
  void initState() {
    super.initState();
    _cargarRegistrosYGuardarTiempo();
  }

  Future<void> _cargarRegistrosYGuardarTiempo() async {
    final ble = context.read<BLEController>();
    final int tiempoActual = ble.getCurrentTimeOn();

    // Guardar tiempo actual
    await TimeRecordHelper.registrarTiempo(tiempoActual);

    // Cargar registros desde Hive
    final datos = await TimeRecordHelper.obtenerTodosLosRegistros();
    final semanas = TimeRecordsUtils.agruparRegistrosPorSemanaLista(datos);

    setState(() {
      _registros = datos;
      _semanas = semanas;
      indiceSeleccionado = semanas.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final registrosFiltrados = TimeRecordsUtils.obtenerRegistrosPorIndice(
      _registros,
      indiceSeleccionado,
    );

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _cargarRegistrosYGuardarTiempo,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Column(
                children: [
                  _buildResumenCard(),
                  const SizedBox(height: 16),
                  _buildOperationCard(registrosFiltrados),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResumenCard() {
    if (_registros.isEmpty) {
      return const InfoCard(
        title: 'Resumen general',
        icon: Icons.query_stats,
        height: 140,
        child: Center(child: Text('Sin datos')),
      );
    }

    final ultimo = _registros.last;
    final double minutosTotal = ultimo.timeMilis / 60000;
    final double minutosLast = ultimo.lastTimeMilis / 60000;

    final String sumaStr = formatearMinutos(minutosTotal);
    final String lastStr = formatearMinutos(minutosLast);
    const String fecha = 'Hoy';

    return InfoCard(
      title: 'Ãšltimo registro',
      icon: Icons.query_stats,
      height: 160,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildResumenItem('Fecha', fecha, Icons.calendar_today),
            _buildResumenItem('Total', sumaStr, Icons.summarize),
            _buildResumenItem('Ãšltimo', lastStr, Icons.update),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenItem(String label, String value, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildOperationCard(List<TimeRecord> registrosFiltrados) {
    return InfoCard(
      title: 'Tiempo de operaciÃ³n semanal',
      icon: Icons.timer,
      height: 400,
      child: Column(
        children: [
          _buildButtonDate(),
          const SizedBox(height: 16),
          WeeklyBarChart(registros: registrosFiltrados),
        ],
      ),
    );
  }

  Widget _buildButtonDate() {
    return GestureDetector(
      onTap: () => _buildSelectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month),
            const SizedBox(width: 16),
            Text('Semana ${indiceSeleccionado + 1}'),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }

  void _buildSelectDate(BuildContext context) async {
    CustomBottomSheet.show(
      initialChildSize: 0.4,
      context: context,
      title: 'Selecciona semana',
      onConfirm: () => Navigator.pop(context, indiceSeleccionado),
      child: PickerItem(
        semanas: _semanas,
        initialIndex: indiceSeleccionado,
        onChanged: (index) => indiceSeleccionado = index,
      ),
    ).then((value) {
      if (value != null && value is int) {
        setState(() {
          indiceSeleccionado = value;
        });
      }
    });
  }

  String formatearMinutos(double minutos) {
    final int horas = minutos ~/ 60;
    final int mins = (minutos % 60).round();

    if (horas > 0 && mins > 0) {
      return '${horas}h ${mins}m';
    } else if (horas > 0) {
      return '${horas}h';
    } else {
      return '${mins}m';
    }
  }
}
