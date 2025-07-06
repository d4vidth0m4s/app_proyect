import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          // Gráfico de barras
          BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          days[value.toInt()],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              barGroups: [
                for (int i = 0; i < 7; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: (i + 1) * 2,
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(6),
                        width: 16,
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Simular bordes blancos arriba de cada barra
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final chartWidth = constraints.maxWidth;
                final spacing = chartWidth / 7;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (i) {
                    final barHeight = ((i + 1) * 2) * 4; // Escala Y aprox
                    return Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(left: 4, right: 4),
                      child: Container(
                        width: 16,
                        height: barHeight + 4,
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 16,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
