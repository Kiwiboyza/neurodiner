import 'package:flutter/material.dart';
import '../widgets/dynamic_app_bar.dart';
import '../widgets/buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DynamicAppBar(
        title: 'NeuroDiner',
        showSettingsButton: true,
        showHelpButton: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to NeuroDiner!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Simplifying Meals for Neurodivergent Minds',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),

            Tooltip(
              message: 'Learn how to use NeuroDiner',
              child: HomePageButton(
                label: 'Learn how to use NeuroDiner',
                onPressed: () {
                  Navigator.pushNamed(context, '/help');
                },
              ),
            ),

            const SizedBox(height: 100),

            Tooltip(
              message: 'Start building a meal plan',
              child: HomePageButton(
                label: 'Make a meal plan',
                onPressed: () {
                  Navigator.pushNamed(context, '/people');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
