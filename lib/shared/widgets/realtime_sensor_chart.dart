import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RealtimeSensorChart extends StatelessWidget {
  final String title;
  final String unit;
  final Color color;
  final List<double> values;

  const RealtimeSensorChart({
    super.key,
    required this.title,
    required this.unit,
    required this.color,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final latest = values.isNotEmpty ? values.last : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              latest == null ? '-- $unit' : '${latest.toStringAsFixed(1)} $unit',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(height: 150, child: _buildChart(theme)),
      ],
    );
  }

  Widget _buildChart(ThemeData theme) {
    if (values.isEmpty) {
      return Center(
        child: Text(
          'Esperando datos...',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      );
    }

    final spots = List<FlSpot>.generate(
      values.length,
      (index) => FlSpot(index.toDouble(), values[index]),
    );
    final maxX = math.max(1, values.length - 1).toDouble();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final hasRange = (maxY - minY).abs() > 0.001;
    final padding = hasRange
        ? (maxY - minY) * 0.15
        : math.max(maxY.abs() * 0.2, 1.0).toDouble();
    final effectiveMinY = math.max(0.0, minY - padding).toDouble();
    final effectiveMaxY = maxY + padding;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX,
        minY: effectiveMinY,
        maxY: effectiveMaxY,
        clipData: const FlClipData.all(),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _buildInterval(effectiveMinY, effectiveMaxY),
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade200, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: math.max(1, (values.length / 4).floor()).toDouble(),
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                if (value == 0) {
                  return _AxisLabel(label: '-${values.length - 1}');
                }
                if (value >= values.length - 1) {
                  return const _AxisLabel(label: 'Ahora');
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: _buildInterval(effectiveMinY, effectiveMaxY),
              getTitlesWidget: (value, meta) => _AxisLabel(
                label: value.toStringAsFixed(0),
                alignEnd: true,
              ),
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots
                  .map(
                    (spot) => LineTooltipItem(
                      '${spot.y.toStringAsFixed(1)} $unit',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                  .toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: values.length <= 10,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: color,
                  strokeWidth: 1.5,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.28),
                  color.withValues(alpha: 0.04),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            spots: spots,
          ),
        ],
      ),
    );
  }

  double _buildInterval(double minY, double maxY) {
    final range = maxY - minY;
    if (range <= 4) return 1;
    if (range <= 10) return 2;
    if (range <= 20) return 5;
    return range / 4;
  }
}

class _AxisLabel extends StatelessWidget {
  final String label;
  final bool alignEnd;

  const _AxisLabel({required this.label, this.alignEnd = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignEnd ? Alignment.centerRight : Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(right: alignEnd ? 8 : 0, top: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
