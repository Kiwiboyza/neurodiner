import 'package:flutter/material.dart';
import '../theme/themes.dart'; // Import your themes

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = defaultTheme; // Default theme
  int _currentSelectedValue = 1; // Track the selected theme (default is 1)
  double _fontSize = 16.0;

  // Getter for the selected theme
  ThemeData get themeData => _themeData;

  // Getter for the current selected value
  int get currentSelectedValue => _currentSelectedValue;
  double get fontSize => _fontSize;

  // Method to update the theme
  void setTheme(ThemeData theme, int selectedValue) {
    _themeData = theme; // Set the theme
    _currentSelectedValue = selectedValue; // Update the selected value
    notifyListeners(); // Notify listeners to update the UI
  }

  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }
}
