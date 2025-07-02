import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget{
  final String title;
  final String value;
  final IconData icon;
  final bool isStatus;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.isStatus = false,
  });
  @override
  Widget build(BuildContext context) {
    final Color statusColor = isStatus ? Colors.green : Colors.white;
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Row( 
            children: [
              Icon(icon, color: Colors.grey[400], size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(color: statusColor, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      )
    );
  }
}