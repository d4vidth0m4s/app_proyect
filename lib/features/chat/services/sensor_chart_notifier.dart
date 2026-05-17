import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

class SensorChartNotifier extends ChangeNotifier {
  final Queue<double> _current = Queue();
  final Queue<double> _temperature = Queue();
  final int limit;

  SensorChartNotifier({this.limit = 1000});

  List<double> get current => List.unmodifiable(_current);
  List<double> get temperature => List.unmodifiable(_temperature);

  void addValues(double currentValue, double tempValue) {
    _addTo(_current, currentValue);
    _addTo(_temperature, tempValue);
    notifyListeners();
  }

  void _addTo(Queue<double> q, double value) {
    q.addLast(value);
    if (q.length > limit) q.removeFirst();
  }

  void clear() {
    _current.clear();
    _temperature.clear();
    notifyListeners();
  }

  Map<String, double> _calculateStats(List<double> values) {
    if (values.isEmpty) return {};

    final sorted = List<double>.from(values)..sort();
    final count = values.length;
    final minValue = sorted.first;
    final maxValue = sorted.last;
    final mean = values.reduce((a, b) => a + b) / count;
    final variance =
        values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) / count;
    final stdDev = sqrt(variance);
    final median = count % 2 == 0
        ? (sorted[count ~/ 2] + sorted[count ~/ 2 - 1]) / 2
        : sorted[count ~/ 2];
    final range = maxValue - minValue;
    final rms =
        sqrt(values.map((v) => v * v).reduce((a, b) => a + b) / count);
    final double crestFactor = rms == 0 ? 0.0 : maxValue / rms;

    double skewness = 0;
    double kurtosis = 0;

    if (stdDev != 0) {
      for (final v in values) {
        final z = (v - mean) / stdDev;
        skewness += pow(z, 3);
        kurtosis += pow(z, 4);
      }
      skewness /= count;
      kurtosis /= count;
    }

    double trend = 0;
    if (count > 1) {
      final middle = count ~/ 2;
      final firstHalf = values.take(middle == 0 ? 1 : middle).toList();
      final secondHalf = values.skip(middle).toList();
      final firstMean =
          firstHalf.reduce((a, b) => a + b) / firstHalf.length;
      final secondMean =
          secondHalf.reduce((a, b) => a + b) / secondHalf.length;
      trend = secondMean - firstMean;
    }

    double slope = 0;
    if (count > 1) {
      final xMean = (count - 1) / 2;
      final yMean = mean;
      double num = 0;
      double den = 0;

      for (int i = 0; i < count; i++) {
        num += (i - xMean) * (values[i] - yMean);
        den += pow(i - xMean, 2);
      }

      slope = den == 0 ? 0 : num / den;
    }

    return {
      'min': minValue,
      'max': maxValue,
      'mean': mean,
      'median': median,
      'range': range,
      'variance': variance,
      'stdDev': stdDev,
      'rms': rms,
      'crestFactor': crestFactor,
      'skewness': skewness,
      'kurtosis': kurtosis,
      'trend': trend,
      'slope': slope,
    };
  }

  double _calculateCorrelation(List<double> x, List<double> y) {
    if (x.length != y.length || x.isEmpty) return 0;

    final n = x.length;
    final meanX = x.reduce((a, b) => a + b) / n;
    final meanY = y.reduce((a, b) => a + b) / n;

    double num = 0;
    double denX = 0;
    double denY = 0;

    for (int i = 0; i < n; i++) {
      num += (x[i] - meanX) * (y[i] - meanY);
      denX += pow(x[i] - meanX, 2);
      denY += pow(y[i] - meanY, 2);
    }

    return (denX == 0 || denY == 0) ? 0 : num / sqrt(denX * denY);
  }

  String buildSensorSummary() {
    final currentStats = _calculateStats(_current.toList());
    final tempStats = _calculateStats(_temperature.toList());

    if (currentStats.isEmpty || tempStats.isEmpty) {
      return 'No hay suficientes datos historicos del sensor para analizar.';
    }

    final correlation =
        _calculateCorrelation(_current.toList(), _temperature.toList());

    return '''
  Motor Sensor Statistical Analysis (${_current.length} samples)

CURRENT SIGNAL

Minimum: ${currentStats['min']!.toStringAsFixed(3)} A
Maximum: ${currentStats['max']!.toStringAsFixed(3)} A
Mean: ${currentStats['mean']!.toStringAsFixed(3)} A
Median: ${currentStats['median']!.toStringAsFixed(3)} A
Range: ${currentStats['range']!.toStringAsFixed(3)} A
Variance: ${currentStats['variance']!.toStringAsFixed(3)}
Standard Deviation: ${currentStats['stdDev']!.toStringAsFixed(3)}
Root Mean Square (RMS): ${currentStats['rms']!.toStringAsFixed(3)} A
Crest Factor: ${currentStats['crestFactor']!.toStringAsFixed(3)}
Skewness: ${currentStats['skewness']!.toStringAsFixed(3)}
Kurtosis: ${currentStats['kurtosis']!.toStringAsFixed(3)}
Trend: ${currentStats['trend']!.toStringAsFixed(3)}
Linear Slope: ${currentStats['slope']!.toStringAsFixed(3)}

TEMPERATURE SIGNAL

Minimum: ${tempStats['min']!.toStringAsFixed(3)} Â°C
Maximum: ${tempStats['max']!.toStringAsFixed(3)} Â°C
Mean: ${tempStats['mean']!.toStringAsFixed(3)} Â°C
Standard Deviation: ${tempStats['stdDev']!.toStringAsFixed(3)} Â°C
Trend: ${tempStats['trend']!.toStringAsFixed(3)}
Linear Slope: ${tempStats['slope']!.toStringAsFixed(3)}

SIGNAL RELATION

Pearson Correlation Coefficient (Current vs Temperature): ${correlation.toStringAsFixed(3)}
''';
  }
}
