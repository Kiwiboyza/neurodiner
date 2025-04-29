import 'package:flutter/material.dart';
import '../widgets/dynamic_app_bar.dart';
import '../functions/functions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        title: 'NeuroDiner',
        showSettingsButton: true,
        showHelpButton: true,
      ),
      body: Center(  // Center widget will horizontally center everything
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // Adjusts spacing between widgets
          crossAxisAlignment: CrossAxisAlignment.center,  // Center everything horizontally
          children: [
            const Text(
              'Welcome to NeuroDiner!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,  // Ensures centered text
            ),
            const Text(
              'Simplifying Meals for Neurodivergent Minds',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,  // Ensures centered text
            ),
            // Adjust spacing with Expanded if you want flexible space distribution
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/help');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkenColor(Theme.of(context).colorScheme.surface),  // Darkened background
                foregroundColor: darkenColor(Theme.of(context).colorScheme.onSurface), // Darkened text color
                minimumSize: const Size(400, 100),  // Consistent width and height
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),  // Rounded corners for a smoother look
                  side: const BorderSide(color: Colors.black, width: 2),  // Black border outline
                ),
              ),
              child: const Text('Using NeuroDiner'),
            ),
            const SizedBox(height: 100),  // Adjust space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/people');  // Adjust the action as needed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkenColor(Theme.of(context).colorScheme.surface),  // Darkened background
                foregroundColor: darkenColor(Theme.of(context).colorScheme.onSurface), // Darkened text color
                minimumSize: const Size(400, 100),  // Consistent width and height
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),  // Rounded corners
                  side: const BorderSide(color: Colors.black, width: 2),  // Black border outline
                ),
              ),
              child: const Text('Make a meal plan'),
            ),
          ],
        ),
      ),
    );
  }
}