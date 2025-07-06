import 'package:flutter/material.dart';

class ControlCard extends StatelessWidget {
  final VoidCallback onEncender;
  final VoidCallback onApagar;
  final VoidCallback onEmergencia;

  const ControlCard({
    super.key,
    required this.onEncender,
    required this.onApagar,
    required this.onEmergencia,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Controles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onEncender,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Encender'),
                ),
                ElevatedButton(
                  onPressed: onApagar,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Apagar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onEmergencia,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('EMERGENCIA'),
            ),
          ],
        ),
      ),
    );
  }
}
