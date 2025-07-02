import 'package:flutter/material.dart';
class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: const Center(
        child: Text(
          'Bienvenido a la pantalla de configuración',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    );
  }
}