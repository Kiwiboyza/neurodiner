import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/dynamic_app_bar.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  int currentStep = 2; // Start at the third step (after the first two steps)
  final List<String> boxTexts = [
    'Welcome to NeuroDiner! This app is designed to help you create delicious meal plans while considering your and your families allergies and sensory preferences, ensuring a simple, effective meal plan that caters to all.',
    'To get started, follow these simple steps:',
    'On the Home Screen, tap the "Make a meal plan" button.',
    'On the People Page, begin by adding the people you are catering for.',
    'For each person, select their allergies, sensory preferences, and days they will be eating at home.',
    'For allergies, select the allergens they want to avoid. When selected, they will be outlined in red, with an X symbol.',
    'For sensory preferences, there is an assortment of options. For each sensory tag, select either the thumbs up, indicating they prefer that type of food, the thumbs down for foods they tend to avoid, or the hyphen for anything else.',
    'Select the days they will be eating at home. They will be shown as toggle switches, GREEN for YES, and RED for NO.',
    'Once you have added all the people and their preferences, tap the "Generate meal plan" button.',
    'On the Meal Plan Page, you will see a list of suggested meals for the week, along with other allergens, sensory tags, notes, and a link to an external recipe. These meals are selected based on the allergens and sensory preferences of the people you added, only for the days where they will be eating.',
    'Save your customised meal plan for future reference.',
    'Enjoy your delicious and allergen-free meals! Bon appétit!',
  ];

  final List<String> disclaimerTexts = [
    'WARNING:',
    'This app is an advisory tool, NOT a substitute for professional medical advice. Always consult with a healthcare professional before making any dietary changes.',
    'NeuroDiner is not responsible for any allergic reactions or adverse effects resulting from the use of this app. Use at your own risk.',
  ];

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);

    // Fetch theme properties
    final TextStyle headerTextStyle = Theme.of(context).textTheme.bodyLarge!;
    final TextStyle bodyTextStyle = Theme.of(context).textTheme.bodyMedium!;
    final Color boxBorderColor = Theme.of(context).colorScheme.primary;
    final Color boxBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color boxTextColor = Theme.of(context).colorScheme.onPrimary;
    final Color errorColor = Theme.of(context).colorScheme.error;

    return Scaffold(
      appBar: DynamicAppBar(
        title: 'How to Use NeuroDiner',
        showSettingsButton: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Always visible first two steps
            Center(
              child: Column(
                children: [
                  Text(
                    boxTexts[0],
                    style: headerTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: boxTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50.0),
                  Text(
                    boxTexts[1],
                    style: bodyTextStyle.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Expanded container for the current step
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: boxBackgroundColor,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.black, width: 3.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display step number
                          Text(
                            'Step ${currentStep - 1}:',
                            style: headerTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: boxTextColor,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          // Display step content
                          Text(
                            boxTexts[currentStep],
                            style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Row with Back and Next buttons, centered with borders
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Back button with border and Tooltip only if enabled
                  currentStep > 2
                      ? Tooltip(
                        message: 'Go to the previous step',
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: boxBorderColor, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                currentStep--;
                              });
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      )
                      : Container(), // Empty container if disabled

                  const SizedBox(width: 16.0),

                  // Next button with border and Tooltip only if enabled
                  currentStep < boxTexts.length - 1
                      ? Tooltip(
                        message: 'Go to the next step',
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: boxBorderColor, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                currentStep++;
                              });
                            },
                            child: const Text(
                              'Next',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      )
                      : Container(), // Empty container if disabled
                ],
              ),
            ),

            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Step ${currentStep - 1} of ${boxTexts.length - 2}',
                style: headerTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: boxTextColor,
                ),
              ),
            ),

            // Disclaimer and Warning Text, with red border
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: errorColor, width: 3),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  // Display Warning
                  Text(
                    disclaimerTexts[0], // Warning text
                    style: headerTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: errorColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  // Display Disclaimer
                  Text(
                    disclaimerTexts[1], // Disclaimer text
                    style: headerTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: errorColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    disclaimerTexts[2], // Disclaimer text
                    style: headerTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: errorColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
