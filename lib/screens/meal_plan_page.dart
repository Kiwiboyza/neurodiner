import 'package:flutter/material.dart';
import 'package:neurodiner/providers/people_provider.dart';
import 'package:provider/provider.dart';
import 'package:neurodiner/widgets/dynamic_app_bar.dart';
import 'package:neurodiner/functions/functions.dart';
import 'package:neurodiner/models/person.dart';
import 'package:neurodiner/constants/constants.dart';

List daylist = List.from(dayNames);

class MealPlanPage extends StatefulWidget {
  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Meal Plan")),
      body: Center(child: Text("Meal plan will appear here")),
    );
  }
}