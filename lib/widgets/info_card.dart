import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
class InfoCard extends StatelessWidget{
  final String title;
  final Widget child;
  final IconData icon;
  final bool isStatus;
  final VoidCallback? onTap;
  final double? height; 

  const InfoCard({
    super.key,
    required this.title,
    required this.child,
    required this.icon,
    this.isStatus = false,
    this.onTap, 
    this.height,
  });
  @override
  Widget build(BuildContext context) {
   
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Row( 
            children: [
              Icon(icon, color: Colors.grey[400], size: 20),
              const SizedBox(width: 2),
              Text(
                title,
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Spacer(), 
          Center(child: child),
          const Spacer(),
        ],
      )
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



Widget ontap({
  required String value, 
  required bool isStatus, 
  required bool isStatusColor,
  required VoidCallback? onTap
  }) {
        
       
        final Color statusColor =
        isStatusColor ? Colors.green :  Colors.redAccent;
  return Row(
    children: [
      Text(
        value,
        style: TextStyle(
            color: statusColor,
            fontSize: 25,
            fontWeight: FontWeight.w600),
      ),
      const Spacer(),
      if(!isStatus) GestureDetector(
        onTap: onTap, // 👈 ejecuta la acción
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
          child: Icon( 
            Icons.power_settings_new_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
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
        radius: 60.0,
        lineWidth: 10.0,
        percent: porcentaje.clamp(0.0, 1.0),
        center: Text("${(porcentaje * 100).toStringAsFixed(1)}%",
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        progressColor: Colors.blue,
        backgroundColor: Colors.grey.shade300,
        circularStrokeCap: CircularStrokeCap.round,
        
        
      ),
    );
  }
}