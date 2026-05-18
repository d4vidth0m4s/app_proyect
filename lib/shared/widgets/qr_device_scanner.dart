import 'dart:convert';

import 'package:app_proyect/shared/widgets/app_feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrDeviceScanner extends StatefulWidget {
  const QrDeviceScanner({
    super.key,
    required this.onConfigDetected,
    required this.scannerHeight,
    required this.scannerWidth,
  });

  final Future<void> Function(Map<String, dynamic> config) onConfigDetected;
  final double scannerHeight;
  final double scannerWidth;

  static const double _borderRadius = 24;
  static const String _errorMessage =
      'El QR no es valido. Debe contener deviceName y deviceId.';

  @override
  State<QrDeviceScanner> createState() => _QrDeviceScannerState();
}

class _QrDeviceScannerState extends State<QrDeviceScanner> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final rawValue = capture.barcodes.isNotEmpty
        ? capture.barcodes.first.rawValue
        : null;
    if (rawValue == null || rawValue.trim().isEmpty) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final decoded = json.decode(rawValue);
      if (decoded is! Map<String, dynamic> ||
          decoded['deviceName'] == null ||
          decoded['deviceId'] == null) {
        throw const FormatException('QR invalido');
      }

      await _scannerController.stop();
      await widget.onConfigDetected(decoded);
    } catch (_) {
      if (!mounted) return;

      AppFeedbackSnackBar.show(
        context,
        message: QrDeviceScanner._errorMessage,
        type: AppFeedbackType.error,
      );

      await _scannerController.stop();
      await _scannerController.start();

      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(QrDeviceScanner._borderRadius),
      child: SizedBox(
        height: widget.scannerHeight,
        width: widget.scannerWidth,
        child: MobileScanner(
          controller: _scannerController,
          onDetect: _handleDetection,
        ),
      ),
    );
  }
}
