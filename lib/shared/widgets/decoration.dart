import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:app_proyect/models/layout_box.dart';
import 'package:flutter/material.dart';

Widget buildDecoration(
  LayoutValues values,
  Animation<Offset>? offset,
  relativeValues relativeValues,
  int index,
) {
  final dx = (offset?.value.dx ?? -1.0) * relativeValues.x;
  final dy = (offset?.value.dy ?? -1.0) * relativeValues.y;

  return Positioned(
    left: index == 1 ? values.yellowLeft + dx : values.pinkLeft + dx,
    top: index == 1 ? values.yellowTop + dy : values.pinkTop + dy,
    child: Transform.rotate(
      angle: relativeValues.angle,
      child: Container(
        width: values.decorativeWidth * relativeValues.width,
        height: values.decorativeHeight * relativeValues.height,
        decoration: BoxDecoration(
          color: relativeValues.color,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
  );
}
