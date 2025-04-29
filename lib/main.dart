import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/people_provider.dart';
import 'routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PeopleProvider>(
          create: (_) => PeopleProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
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



