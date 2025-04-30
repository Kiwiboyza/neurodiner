import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/people_provider.dart';
import 'providers/settings_provider.dart';
import 'routes.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:core';
import 'meal.dart';

late Box<Meal> box;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MealAdapter());
  box = await Hive.openBox<Meal>('Meal');

  String csv = 'meals.csv';
  String fileData = await rootBundle.loadString(csv);
  List<String> rows = fileData.split("\n");

  for (int i = 1; i < rows.length; i++) {
    String row = rows[i];
    if (row.trim().isEmpty) continue;

    List<String> itemInRow = row.split(",");

    List<String> allergens = itemInRow[4].split(";");
    List<String> preferences = itemInRow[5].split(";");

    Meal meal = Meal(
      id: itemInRow[0],
      name: itemInRow[1],
      categoryID: itemInRow[2],
      timeOfDay: itemInRow[3],
      allergens: allergens,
      sensoryTags: preferences,
      calories: int.tryParse(itemInRow[6]) ?? 0,
      notes: itemInRow[7],
      externalUrl: itemInRow[8],
    );

    await box.put(meal.id, meal);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PeopleProvider>(create: (_) => PeopleProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Builder(
      builder: (context) {
        return MaterialApp(
          title: 'NeuroDiner',
          theme: themeProvider.themeData,
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQueryData.copyWith(
                textScaler: TextScaler.linear(
                  (themeProvider.fontSize / 16.0).clamp(0.8, 2.0),
                ),
              ),
              child: child!,
            );
          },
          initialRoute: '/home',
          routes: Routes.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
