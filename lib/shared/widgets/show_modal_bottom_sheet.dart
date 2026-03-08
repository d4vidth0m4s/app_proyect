import 'package:flutter/material.dart';

class CustomBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    required String title,

    required VoidCallback onConfirm,
    double initialChildSize = 0.6,
    double minChildSize = 0.4,
    double maxChildSize = 0.9,
    Color? backgroundColor,
    double borderRadius = 35,
    bool isScrollControlled = true,
    EdgeInsets padding = const EdgeInsets.all(16.0),
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor ?? Colors.white.withOpacity(0.97),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: onConfirm,
                          child: const Text('Confirmar'),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: padding, child: child),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
