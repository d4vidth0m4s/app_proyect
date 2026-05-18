import 'package:flutter/material.dart';

enum AppFeedbackType { info, success, error }

class AppFeedbackSnackBar extends StatelessWidget {
  const AppFeedbackSnackBar({
    super.key,
    required this.message,
    this.type = AppFeedbackType.info,
  });

  final String message;
  final AppFeedbackType type;

  static void show(
    BuildContext context, {
    required String message,
    AppFeedbackType type = AppFeedbackType.info,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: AppFeedbackSnackBar(message: message, type: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = _schemeFor(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: scheme.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(scheme.icon, color: scheme.iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: scheme.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _SnackBarScheme _schemeFor(AppFeedbackType type) {
    switch (type) {
      case AppFeedbackType.success:
        return const _SnackBarScheme(
          backgroundColor: Color(0xFFE9F8EE),
          borderColor: Color(0xFF8FD19E),
          iconColor: Color(0xFF1E8E3E),
          textColor: Color(0xFF1D4D2C),
          icon: Icons.check_circle_rounded,
        );
      case AppFeedbackType.error:
        return const _SnackBarScheme(
          backgroundColor: Color(0xFFFDECEC),
          borderColor: Color(0xFFF1A7A7),
          iconColor: Color(0xFFC62828),
          textColor: Color(0xFF6A1B1B),
          icon: Icons.error_rounded,
        );
      case AppFeedbackType.info:
        return const _SnackBarScheme(
          backgroundColor: Color(0xFFEAF3FF),
          borderColor: Color(0xFF9FC5FF),
          iconColor: Color(0xFF1565C0),
          textColor: Color(0xFF123A67),
          icon: Icons.info_rounded,
        );
    }
  }
}

class _SnackBarScheme {
  const _SnackBarScheme({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;
}
