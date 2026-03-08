import 'package:app_proyect/models/layout_box.dart';
import 'package:flutter/material.dart';

LayoutValues calculateLayoutValues(Size screenSize) {
  final screenWidth = screenSize.width;
  final screenHeight = screenSize.height;

  return LayoutValues(
    containerWidth: screenWidth.clamp(0, 412),
    containerHeight: screenHeight,
    borderRadius: 50,
    decorativeWidth: screenWidth * 0.9,
    decorativeHeight: screenWidth * 0.9 * (339 / 410),
    yellowLeft: screenWidth * 0.4,
    yellowTop: screenHeight * 0.78,
    pinkLeft: screenWidth * 0.32,
    pinkTop: screenHeight * .79,
  );
}
