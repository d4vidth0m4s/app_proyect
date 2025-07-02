import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
        Padding(padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: InfoCard(
                  title: 'Temperatura', 
                  value: '22°C', 
                  icon: Icons.thermostat_outlined,
                  ),

                ),
                const SizedBox(width: 16),

                Expanded(child: InfoCard(
                  title: 'RPM', 
                  value: '1500', 
                  icon: Icons.speed_outlined,
                  ),

                ),
                const SizedBox(width: 16),

                
              ],
            ),
             const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: InfoCard(
                  title: 'Temperatura', 
                  value: '22°C', 
                  icon: Icons.thermostat_outlined,
                  ),

                ),
                const SizedBox(width: 16),

                Expanded(child: InfoCard(
                  title: 'RPM', 
                  value: '1500', 
                  icon: Icons.speed_outlined,
                  ),

                ),
                const SizedBox(width: 16),
                
              ],
            ),
            const Spacer(),
          ],
        ),
        )
        ),
      
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    );
  }
}