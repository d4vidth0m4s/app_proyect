import 'package:flutter/material.dart';

class AlertMessage {
  final String text;
  final DateTime timestamp;

  AlertMessage({required this.text, required this.timestamp});
}

class AlertProvider extends ChangeNotifier {
  final List<AlertMessage> _alerts = [];
  int _lastAlertValue = 0;

  List<AlertMessage> get alerts => List.unmodifiable(_alerts);

  void processAlertBits(int bits) {
    if (bits == _lastAlertValue) return;
    _lastAlertValue = bits;

    if ((bits & 0x01) != 0) _add("🚨 Temperatura fuera de rango");
    if ((bits & 0x02) != 0) _add("🚨 RPM fuera de rango");
    if ((bits & 0x04) != 0) _add("🚨 Corriente fuera de rango");
  }

  void _add(String message) {
    _alerts.add(AlertMessage(text: message, timestamp: DateTime.now()));
    notifyListeners();
  }
}
