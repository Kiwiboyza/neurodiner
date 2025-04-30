import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/settings_page.dart';
import 'screens/help_page.dart';
import 'screens/people_page.dart';
import 'screens/preferences_page.dart';
import 'screens/allergens_page.dart';
import 'screens/days_page.dart';
import 'screens/meal_plan_page.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> get routes => {
    '/home': (context) => const HomePage(),
    '/settings': (context) => const SettingsPage(),
    '/help': (context) => HelpPage(),
    '/people': (context) => PeoplePage(),
    '/preferences': (context) => SensoryPreferencesPage(),
    '/allergens': (context) => AllergensPage(),
    '/days': (context) => DaysPage(),
    '/mealplan': (context) => const MealPlanPage(),
  };
}
