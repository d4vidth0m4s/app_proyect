import 'package:flutter/material.dart';

class LayoutValues {
  final double containerWidth;
  final double containerHeight;
  final double borderRadius;
  final double decorativeWidth;
  final double decorativeHeight;
  final double yellowLeft;
  final double yellowTop;
  final double pinkLeft;
  final double pinkTop;

  const LayoutValues({
    required this.containerWidth,
    required this.containerHeight,
    required this.borderRadius,
    required this.decorativeWidth,
    required this.decorativeHeight,
    required this.yellowLeft,
    required this.yellowTop,
    required this.pinkLeft,
    required this.pinkTop,
  });
}

class relativeValues {
  final double x;
  final double y;
  final double angle;
  final double height;
  final double width;
  final Color color;

  const relativeValues({
    this.x = 1,
    this.y = 1,
    this.angle = 0,
    this.height = 1,
    this.width = 1,
    required this.color,
  });
}
