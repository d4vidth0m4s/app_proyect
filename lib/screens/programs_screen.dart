import 'package:flutter/material.dart';
import '../widgets/weekly_bar_chart.dart';
class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
   
    body: Center(child: WeeklyBarChart()),
  );
  }
}