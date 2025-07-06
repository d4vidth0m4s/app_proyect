import 'package:flutter/material.dart';

class ConnectionCard extends StatelessWidget {
  final bool isConnected;

  const ConnectionCard({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Estado de Conexión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                  color: isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  isConnected ? 'Conectado' : 'Desconectado',
                  style: TextStyle(
                    color: isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
