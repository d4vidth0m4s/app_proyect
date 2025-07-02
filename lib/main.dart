import 'package:flutter/material.dart';
import 'widgets/bottom_navigation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App con Bottom Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BottomNavigation(), // Usa tu BottomNavigation aquí
      debugShowCheckedModeBanner: false, // Opcional: quita el banner de debug
    );
  }
}