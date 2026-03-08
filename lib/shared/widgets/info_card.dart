import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class InfoCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final IconData? icon;
  final bool isStatus;
  final VoidCallback? onTap;
  final double? height;

  const InfoCard({
    super.key,
    this.title,
    required this.child,
    this.icon,
    this.isStatus = false,
    this.onTap,
    this.height,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              children: [
                Icon(icon, color: Colors.grey[400], size: 20),
                const SizedBox(width: 2),
                Text(
                  title ?? '',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          const Spacer(),
          Center(child: child),
          const Spacer(),
        ],
      ),
    );
  }
}

Widget buildStyledValueText({
  required String text,
  double fontSize = 25,
  FontWeight fontWeight = FontWeight.w600,
}) {
  return Container(
    alignment: Alignment.center,
    child: Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget ontap2({
  required bool isStatus,
  required bool isStatusColor,
  required VoidCallback? onTap,
}) {
  final Color statusColor = isStatusColor
      ? AppColors.primaryVariant
      : Colors.redAccent;

  return Center(
    // â¬…ï¸ Cambiado aquÃ­
    child: Visibility(
      visible: !isStatus,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          width: 100, //%
          height: 100,
          decoration: const BoxDecoration(
            color: Color.fromARGB(8, 0, 0, 0),
            shape: BoxShape.circle,
          ),
          child: Container(
            alignment: Alignment.center,
            width: 80, //%
            height: 80,
            decoration: const BoxDecoration(
              color: Color.fromARGB(8, 0, 0, 0),
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 50, //%
              height: 50, //%
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.power_settings_new_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget ontap({
  required String value,
  required bool isStatus,
  required bool isStatusColor,
  required VoidCallback? onTap,
}) {
  final Color statusColor = isStatusColor ? Colors.green : Colors.redAccent;
  return Row(
    children: [
      Text(
        value,
        style: TextStyle(
          color: statusColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      const Spacer(),
    ],
  );
}

class MiIndicadorCircular extends StatelessWidget {
  final double porcentaje; // valor entre 0.0 y 1.0

  const MiIndicadorCircular({super.key, required this.porcentaje});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        radius: 40.0,
        lineWidth: 5.0,
        percent: porcentaje.clamp(0.0, 1.0),
        center: Text(
          "${(porcentaje * 100).toStringAsFixed(1)}%",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        progressColor: Colors.blue,
        backgroundColor: Colors.grey.shade300,
        circularStrokeCap: CircularStrokeCap.round,
      ),
    );
  }
}
