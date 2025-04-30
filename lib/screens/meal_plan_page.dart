import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neurodiner/models/person.dart';
import 'package:neurodiner/meal.dart';
import 'package:neurodiner/widgets/dynamic_app_bar.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:neurodiner/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  List<DailyMeal> dailyMeals = [];
  List<String> allDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  void initState() {
    super.initState();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is List<Person>) {
      generateMealPlan(args);
    }
  }

  String getNextMondayDateString() {
    DateTime now = DateTime.now();
    DateTime nextMonday = now.add(Duration(days: 8 - now.weekday));
    return DateFormat('EEEE, MMMM d, y').format(nextMonday);
  }

  Future<void> generateMealPlan(List<Person> people) async {
    List<DailyMeal> plan = [];
    var box = await Hive.openBox<Meal>('Meal');
    List<Meal> allMeals = box.values.toList();
    Set<int> usedCategoryIDs = {}; // one meal per category per week

    for (String day in allDays) {
      List<Person> presentPeople = people.where((p) => p.days.contains(day)).toList();

      Set<String> blockedAllergens = presentPeople.expand((p) => p.allergens).map((a) => a.toLowerCase()).toSet();
      Set<String> avoidances = presentPeople.expand((p) => p.avoidances).map((a) => a.toLowerCase()).toSet();

      List<Meal> eligibleMeals = allMeals.where((meal) {
        bool noBlockedAllergens = meal.allergens.every((a) => !blockedAllergens.contains(a.toLowerCase()));
        bool noAvoidedTags = meal.sensoryTags.every((t) => !avoidances.contains(t.toLowerCase()));
        bool newCategory = !usedCategoryIDs.contains(meal.categoryID);
        return noBlockedAllergens && noAvoidedTags && newCategory;
      }).toList();

      if (eligibleMeals.isNotEmpty) {
        Meal chosen = eligibleMeals[Random().nextInt(eligibleMeals.length)];
        plan.add(DailyMeal(day, chosen));
        usedCategoryIDs.add(int.parse(chosen.categoryID));
      }
    }

    setState(() {
      dailyMeals = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DynamicAppBar(
        title: 'Meal Plan',
        showHelpButton: true,
        showHomeButton: true,
        showSettingsButton: true,
      ),
      body: SingleChildScrollView(
        child: _buildMealPlanTable(),
      ),
    );
  }

  Widget _buildMealPlanTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Meal plan for week commencing',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(getNextMondayDateString()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildTable(),
        ),
      ],
    );
  }

  Widget _buildTable() {
  // This will be wired to your settings in the future
  final showCalories = context.watch<SettingsProvider>().showCalories;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(3),
      },
      children: [
        TableRow(
          children: [
            _buildTableCell('Day'),
            _buildTableCell('Time of Day'),            
            _buildTableCell('Meal Name'),
            if (showCalories) _buildTableCell('Calories'),
            _buildTableCell('Allergens'),
            _buildTableCell('Sensory Tags'),
          ],
        ),
        if (dailyMeals.isNotEmpty)
          for (var dailyMeal in dailyMeals)
            TableRow(
              children: [
                _buildTableCell(dailyMeal.day),
                _buildTableCell(dailyMeal.meal.timeOfDay),
                _buildTableCell(dailyMeal.meal.name),
                if (showCalories)
                  _buildTableCell(dailyMeal.meal.calories.toString()),
                _buildTableCell(dailyMeal.meal.allergens.join(', ')),
                _buildTableCell(dailyMeal.meal.sensoryTags.join(', ')),
              ],
            ),
      ],
    ),
  );
}


  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class DailyMeal {
  String day;
  Meal meal;
  DailyMeal(this.day, this.meal);
} // Ensure this is in the same or imported file

Future<List<DailyMeal>> chooseMeals(List<Person> people) async {
  final box = await Hive.openBox<Meal>('Meal');
  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List<int> selectedCategoryIDs = [];
  List<DailyMeal> dailyMeals = [];

  for (String day in days) {
    final presentPeople = people.where((p) => p.days.contains(day)).toList();

    final blockedAllergens = presentPeople.expand((p) => p.allergens).map((a) => a.toLowerCase().trim()).toSet();
    final avoidances = presentPeople.expand((p) => p.avoidances).map((a) => a.toLowerCase().trim()).toSet();
    final preferences = presentPeople.expand((p) => p.preferences).map((a) => a.toLowerCase().trim()).toSet();

    bool mealSatisfies(Meal meal) {
      final mealAllergens = meal.allergens.map((a) => a.toLowerCase().trim()).toSet();
      final sensoryTags = meal.sensoryTags.map((t) => t.toLowerCase().trim()).toSet();

      final hasBlockedAllergens = mealAllergens.intersection(blockedAllergens).isNotEmpty;
      final hasAvoidedSensory = sensoryTags.intersection(avoidances).isNotEmpty;
      final categoryAlreadyUsed = selectedCategoryIDs.contains(meal.categoryID);

      return !hasBlockedAllergens && !hasAvoidedSensory && !categoryAlreadyUsed;
    }

    final eligibleMeals = box.values.where(mealSatisfies).toList();

    if (eligibleMeals.isNotEmpty) {
      final chosenMeal = eligibleMeals[Random().nextInt(eligibleMeals.length)];
      dailyMeals.add(DailyMeal(day, chosenMeal));
      selectedCategoryIDs.add(chosenMeal.categoryID as int);
    }
  }

  return dailyMeals;
}