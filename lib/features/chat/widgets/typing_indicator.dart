import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "...",
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
