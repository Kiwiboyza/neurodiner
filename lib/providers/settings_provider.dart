import 'package:flutter/material.dart';

//Change Notifier for Calories toggle
class SettingsProvider extends ChangeNotifier {
  bool _showCalories = true;

  bool get showCalories => _showCalories;

  void toggleShowCalories(bool value) {
    _showCalories = value;
    notifyListeners();
  }
}
