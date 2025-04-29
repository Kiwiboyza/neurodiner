import 'package:flutter/material.dart';

// Theme 1: Basic Soft Colour Theme
final ThemeData defaultTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 136, 171, 223),
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF64B5F6),
    secondary: const Color(0xFFE57373),
    surface: const Color(0xFFF5F7FA),
    onPrimary: Colors.black87,
    onSecondary: Colors.black87,
    onSurface: Colors.black87,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
);


// Theme 2: Protanopia-Friendly Theme
final ThemeData protaTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 130, 164, 197), // light background
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF4CAF50), // richer green
    secondary: const Color(0xFFFF7043), // soft coral
    surface: const Color(0xFFF7F9FB),
    onPrimary: Colors.black87,
    onSecondary: Colors.black87,
    onSurface: Colors.black87,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
);

// Theme 3: Deuteranopia-Friendly Theme
final ThemeData deuterTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 54, 114, 175),
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF42A5F5), // stronger blue
    secondary: const Color(0xFFFF7043), // coral
    surface: const Color(0xFFF7F8F9),
    onPrimary: Colors.black87,
    onSecondary: Colors.black87,
    onSurface: Colors.black87,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
);

// Theme 4: Tritanopia-Friendly Theme
final ThemeData tritaTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 60, 156, 84),
  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 39, 85, 51), // cool teal blue
    secondary: const Color(0xFFEF9A9A), // soft pink
    surface: const Color(0xFFF9FAFB),
    onPrimary: Colors.black87,
    onSecondary: Colors.black87,
    onSurface: Colors.black87,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
);

// Theme 5: Achromatopsia (Greyscale) Theme
final ThemeData achromaTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 161, 161, 161), // soft light grey
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFFB0B0B0), // soft grey
    secondary: const Color(0xFF888888), // slightly darker grey
    surface: const Color(0xFFF2F2F2),
    onPrimary: Colors.black87,
    onSecondary: Colors.black87,
    onSurface: Colors.black87,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
);





