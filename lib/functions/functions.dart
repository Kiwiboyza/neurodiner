import 'package:flutter/material.dart';

// Function to darken the color
Color darkenColor(Color color) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness(
    (hsl.lightness - 0.2).clamp(0.0, 1.0),
  ); // Darken by 20%
  return hslDark.toColor();
}
