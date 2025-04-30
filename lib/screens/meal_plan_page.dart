import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neurodiner/models/person.dart';
import 'package:neurodiner/meal.dart';
import 'package:neurodiner/widgets/dynamic_app_bar.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:neurodiner/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:neurodiner/constants/constants.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  MealPlanPageState createState() => MealPlanPageState();
}

class MealPlanPageState extends State<MealPlanPage> {
  List<DailyMeal> dailyMeals = [];
  bool _hasLoaded = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is List<Person>) {
        generateMealPlan(args);
      }
      _hasLoaded = true;
    }
  }

// Get the next Monday date as a string
  String getNextMondayDateString() {
    DateTime now = DateTime.now();
    DateTime nextMonday = now.add(Duration(days: 8 - now.weekday));
    return DateFormat('EEEE, MMMM d, y').format(nextMonday);
  }

// Generate a meal plan based on the provided list of people
  Future<void> generateMealPlan(List<Person> people) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<DailyMeal> plan = [];
      var box = await Hive.openBox<Meal>('Meal');
      List<Meal> allMeals = box.values.toList();
      if (allMeals.isEmpty) {
        throw Exception('No meals available in the database.');
      }

      Set<String> usedCategoryIDs = {}; // one meal per category per week

      for (String day in dayNames) {
        List<Person> presentPeople =
            people.where((p) => p.days.contains(day)).toList();

        Set<String> blockedAllergens = {};
        Set<String> avoidances = {};

        // Aggregate allergens and avoidances based on people present on the day
        for (var person in presentPeople) {
          blockedAllergens.addAll(person.allergens.map((a) => a.toLowerCase()));
          avoidances.addAll(person.avoidances.map((a) => a.toLowerCase()));
        }

        // Meals eligible for selection based on allergens, sensory preferences, and category
        List<Meal> eligibleMeals =
            allMeals.where((meal) {
              // Filter out meals with blocked allergens
              bool noBlockedAllergens = meal.allergens.every(
                (mealAllergen) =>
                    !blockedAllergens.contains(mealAllergen.toLowerCase()),
              );

              // Filter out meals with sensory tags that are avoided
              bool noAvoidedTags = meal.sensoryTags.every(
                (tag) => !avoidances.contains(tag.toLowerCase()),
              );

              bool newCategory = !usedCategoryIDs.contains(meal.categoryID);

              return noBlockedAllergens && noAvoidedTags && newCategory;
            }).toList();

        if (eligibleMeals.isNotEmpty) {
          // Selecting the meal for the day randomly from the eligible meals
          Meal chosen = eligibleMeals[Random().nextInt(eligibleMeals.length)];
          plan.add(DailyMeal(day, chosen));
          usedCategoryIDs.add(chosen.categoryID); // Ensure no category repeats
        } else {
          // If no meal can be chosen, add a placeholder
          plan.add(
            DailyMeal(day, Meal.noMeal()),
          ); // Placeholder for no meal selected
        }
      }

      setState(() {
        dailyMeals = plan;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to generate meal plan: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Re-roll a meal for a specific day using the allergens and preferences of the people present on that day
  Future<void> reRollMeal(int index) async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! List<Person>) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'No user data available for reroll.'; // Reset any previous error message
      });
      return;
    }

    List<Person> people = args;

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset any previous error message
    });

    try {
      // Fetch the list of all meals from Hive
      List<Meal> allMeals = (await Hive.openBox<Meal>('Meal')).values.toList();

      if (!mounted) return;

      if (allMeals.isEmpty) {
        throw Exception('No meals available in the database.');
      }

      // Get the current meal for the selected day
      DailyMeal oldMeal = dailyMeals[index];
      String day = oldMeal.day;

      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is! List<Person>) {
        throw Exception('No user data available for reroll.');
      }

      List<Person> presentPeople =
          people.where((p) => p.days.contains(day)).toList();

      Set<String> blockedAllergens = {};
      Set<String> avoidances = {};

      for (var person in presentPeople) {
        blockedAllergens.addAll(person.allergens.map((a) => a.toLowerCase()));
        avoidances.addAll(person.avoidances.map((a) => a.toLowerCase()));
      }

      Set<String> usedCategories =
          dailyMeals
              .where(
                (dm) => dm != oldMeal,
              ) // Exclude current day's meal from used set
              .map((dm) => dm.meal.categoryID)
              .toSet();

      // Filter meals based on allergens and sensory preferences
      List<Meal> eligibleMeals =
          allMeals.where((meal) {
            bool noBlockedAllergens = meal.allergens.every(
              (a) => !blockedAllergens.contains(a.toLowerCase()),
            );
            bool noAvoidedTags = meal.sensoryTags.every(
              (t) => !avoidances.contains(t.toLowerCase()),
            );
            bool newCategory = !usedCategories.contains(meal.categoryID);
            return noBlockedAllergens && noAvoidedTags && newCategory;
          }).toList();

      if (eligibleMeals.isNotEmpty) {
        Meal chosen = eligibleMeals[Random().nextInt(eligibleMeals.length)];
        setState(() {
          dailyMeals[index] = DailyMeal(day, chosen);
        });
      } else {
        setState(() {
          dailyMeals[index] = DailyMeal(day, Meal.noMeal());
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DynamicAppBar(
        title: 'Meal Plan',
        showHelpButton: true,
        showSettingsButton: true,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(child: _buildMealPlanTable()),
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
              if (_errorMessage != null) ...[
                SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16.0),
                ),
              ],
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
    final showCalories = context.watch<SettingsProvider>().showCalories;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(),
        columnWidths: {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(2),
          5: FlexColumnWidth(3),
          6: FlexColumnWidth(3),
          7: FlexColumnWidth(3),
          if (showCalories) 8: FlexColumnWidth(2),
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
              _buildTableCell('Notes'),
              _buildTableCell('Recipe Link'),
              _buildTableCell('New Meal'),
            ],
          ),
          if (dailyMeals.isNotEmpty)
            for (int i = 0; i < dailyMeals.length; i++)
              TableRow(
                children: [
                  _buildTableCell(dailyMeals[i].day),
                  _buildTableCell(dailyMeals[i].meal.timeOfDay),
                  _buildTableCell(dailyMeals[i].meal.name),
                  if (showCalories)
                    _buildTableCell(
                      dailyMeals[i].meal.calories > 0
                          ? dailyMeals[i].meal.calories.toString()
                          : 'N/A',
                    ),
                  _buildTableCell(
                    dailyMeals[i].meal.allergens.isNotEmpty
                        ? dailyMeals[i].meal.allergens.join(', ')
                        : 'No Allergens',
                  ),
                  _buildTableCell(
                    dailyMeals[i].meal.sensoryTags.isNotEmpty
                        ? dailyMeals[i].meal.sensoryTags.join(', ')
                        : 'No Sensory Tags',
                  ),
                  _buildTableCell(
                    dailyMeals[i].meal.notes.isNotEmpty
                        ? dailyMeals[i].meal.notes
                        : 'No Notes',
                  ),
                  _buildTableCell(
                    dailyMeals[i].meal.externalUrl.isNotEmpty
                        ? dailyMeals[i].meal.externalUrl
                        : 'No Link',
                  ),

                  _buildTableCellWidget(
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => reRollMeal(i),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String value) {
    return Padding(padding: const EdgeInsets.all(8.0), child: Text(value));
  }

  Widget _buildTableCellWidget(Widget widget) {
    return Padding(padding: const EdgeInsets.all(8.0), child: widget);
  }
}

class DailyMeal {
  String day;
  Meal meal;
  DailyMeal(this.day, this.meal);
}
