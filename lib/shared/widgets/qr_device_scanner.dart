import 'dart:convert';

import 'package:app_proyect/shared/widgets/app_feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrDeviceScanner extends StatefulWidget {
  const QrDeviceScanner({
    super.key,
    required this.onConfigDetected,
    this.title,
    this.description,
    this.scannerHeight = 200,
    this.scannerWidth = double.infinity,
    this.borderRadius = 24,
    this.errorMessage =
        'El QR no es valido. Debe contener deviceName y deviceId.',
    this.idleMessage = 'Apunta la camara al codigo QR.',
    this.processingMessage = 'Procesando configuracion...',
    this.cardColor = Colors.white,
    this.accentColor = const Color(0xFF1E88E5),
    this.statusIcon = Icons.qr_code_scanner_rounded,
  });

  final Future<void> Function(Map<String, dynamic> config) onConfigDetected;
  final String? title;
  final String? description;
  final double scannerHeight;
  final double scannerWidth;
  final double borderRadius;
  final String errorMessage;
  final String idleMessage;
  final String processingMessage;
  final Color cardColor;
  final Color accentColor;
  final IconData statusIcon;

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
        message: widget.errorMessage,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
        ],
        if (widget.description != null) ...[
          Text(
            widget.description!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
        ],
        Container(
          width: widget.scannerWidth,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: widget.cardColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.accentColor.withOpacity(0.22),
              width: 1.4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.statusIcon, color: widget.accentColor),
                  const SizedBox(width: 8),
                  Text(
                    'Escaner QR',
                    style: TextStyle(
                      color: widget.accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius - 8),
                child: SizedBox(
                  height: widget.scannerHeight,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MobileScanner(
                        controller: _scannerController,
                        onDetect: _handleDetection,
                      ),
                      IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: widget.accentColor.withOpacity(0.85),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(
                              widget.borderRadius - 8,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.08),
                                Colors.transparent,
                                Colors.black.withOpacity(0.12),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Text(
                  _isProcessing
                      ? widget.processingMessage
                      : widget.idleMessage,
                  key: ValueKey(_isProcessing),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
