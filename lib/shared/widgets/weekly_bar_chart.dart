import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:app_proyect/models/time_record.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<TimeRecord> registros;

  const WeeklyBarChart({super.key, required this.registros});

  @override
  Widget build(BuildContext context) {
    final List<String> dias = registros
        .map((r) => r.fecha.replaceFirst('-', '\n'))
        .toList();

    final List<double> valoresMin = registros
        .map((r) => (r.timeMilis / 60000).toDouble())
        .toList();

    final List<String> valoresFormateados = valoresMin
        .map((min) => formatearMinutos(min))
        .toList();

    final double maxY = valoresMin.isNotEmpty
        ? valoresMin.reduce((a, b) => a > b ? a : b) + 10
        : 60;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: BarChart(
          BarChartData(
            maxY: maxY,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    valoresFormateados[group.x.toInt()],
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  interval: 30, // Intervalo en minutos
                  getTitlesWidget: (value, meta) {
                    if (value < 0) return const SizedBox();
                    return Text(
                      formatearMinutos(value),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        height: 1.2,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= dias.length)
                      return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: SizedBox(
                        width: 40,
                        child: Text(
                          dias[index],
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            height: 1.2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 30,
              getDrawingHorizontalLine: (value) {
                return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
              },
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(valoresMin.length, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: valoresMin[i],
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.shade100,
                        Colors.blue.shade600,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    width: 18,
                    borderRadius: BorderRadius.circular(8),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxY,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  String formatearMinutos(double minutos) {
    final int horas = minutos ~/ 60;
    final int mins = (minutos % 60).round();

    if (horas > 0 && mins > 0) {
      return '${horas}h\n${mins}m';
    } else if (horas > 0) {
      return '${horas}h';
    } else {
      return '${mins}m';
    }
  }
}
