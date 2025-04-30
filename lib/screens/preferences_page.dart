import 'package:flutter/material.dart';
import 'package:neurodiner/constants/constants.dart';
import '../widgets/dynamic_app_bar.dart';
import '../models/person.dart';

class SensoryPreferencesPage extends StatefulWidget {
  const SensoryPreferencesPage({super.key});

  @override
  State<SensoryPreferencesPage> createState() => SensoryPreferencesPageState();
}

class SensoryPreferencesPageState extends State<SensoryPreferencesPage> {
  late List<int> preferenceStates;
  late List<bool> preferences;
  late List<bool> avoidances;
  late Person person;

  @override
  void initState() {
    super.initState();
    preferences = List<bool>.filled(preferenceNames.length, false);
    avoidances = List<bool>.filled(preferenceNames.length, false);
    preferenceStates = List<int>.filled(preferenceNames.length, 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Grab the person from the route arguments when the page is first loaded or re-loaded
    person = ModalRoute.of(context)!.settings.arguments as Person;

    // Ensure the preferences and avoidances are correctly loaded when navigating back
    for (int i = 0; i < preferenceNames.length; i++) {
      if (person.preferences.contains(preferenceNames[i])) {
        preferences[i] = true;
        avoidances[i] = false;
        preferenceStates[i] = 2; // Mark as "liked" or preferred
      } else if (person.avoidances.contains(preferenceNames[i])) {
        avoidances[i] = true;
        preferences[i] = false;
        preferenceStates[i] = 1; // Mark as "avoid" or disliked
      } else {
        preferences[i] = false;
        avoidances[i] = false;
        preferenceStates[i] = 0; // Neutral state
      }
    }
  }

  // Helper method to toggle preference states
  void _togglePreference(int index, int state) {
    setState(() {
      if (state == 2 && person.preferences.length >= maxPreferences) {
        // If the user tries to add more preferences than allowed, show an alert
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You can only select up to $maxPreferences preferences.',
            ),
          ),
        );
        return; // Exit the method if the limit is reached
      } else if (state == 1 && person.avoidances.length >= maxAvoidances) {
        // Similarly for avoidances
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You can only select up to $maxAvoidances avoidances.',
            ),
          ),
        );
        return;
      }

      preferenceStates[index] = state;
      if (state == 2) {
        person.preferences.add(preferenceNames[index]);
        person.avoidances.remove(preferenceNames[index]);
      } else if (state == 1) {
        person.preferences.remove(preferenceNames[index]);
        person.avoidances.add(preferenceNames[index]);
      } else {
        person.preferences.remove(preferenceNames[index]);
        person.avoidances.remove(preferenceNames[index]);
      }
    });
  }

  // Helper method to build preference/avoidance buttons
  IconButton _buildPreferenceButton(
    int index,
    int state,
    String tooltipMessage,
    IconData icon,
    Color color,
  ) {
    return IconButton(
      icon: Icon(
        icon,
        color:
            preferenceStates[index] == state
                ? color
                : Colors.grey, // Icon color based on state
        size: 30,
      ),
      onPressed: () {
        // Check if the action is allowed based on the current limit
        if (state == 2 && person.preferences.length >= maxPreferences) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You can only select up to $maxPreferences preferences.',
              ),
            ),
          );
          return; // Prevent action
        } else if (state == 1 && person.avoidances.length >= maxAvoidances) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You can only select up to $maxAvoidances avoidances.',
              ),
            ),
          );
          return;
        }
        _togglePreference(index, state);
      },
      tooltip: tooltipMessage,
    );
  }

  // Method to reset preferences and avoidances
  void _resetPreferences() {
    setState(() {
      preferenceStates = List<int>.filled(
        preferenceNames.length,
        0,
      ); // Reset all states to 0 (Neutral)
      person.preferences.clear();
      person.avoidances.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        title: 'Preferences for ${person.name}',
        showHelpButton: true,
        showSettingsButton: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: preferenceNames.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(preferenceNames[index]),
                      subtitle: Text(preferenceExamples[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPreferenceButton(
                            index,
                            2,
                            'Mark as Liked/Preferred',
                            Icons.thumb_up,
                            Colors.green,
                          ),
                          _buildPreferenceButton(
                            index,
                            0,
                            'Remove Preference',
                            Icons.remove,
                            Colors.black,
                          ),
                          _buildPreferenceButton(
                            index,
                            1,
                            'Mark as Avoided/Disliked',
                            Icons.thumb_down,
                            Colors.red,
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1.0),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Reset preferences button
                Tooltip(
                  message: 'Reset all preferences',
                  child: ElevatedButton(
                    onPressed: _resetPreferences,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: const Text(
                      'Reset Preferences',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Save preferences button with limitation on enabling it
                Tooltip(
                  message: 'Save preferences and return',
                  child: ElevatedButton(
                    onPressed:
                        person.preferences.length <= maxPreferences &&
                                person.avoidances.length <= maxAvoidances
                            ? () {
                              // Return the updated person to the PeoplePage
                              Navigator.pop(context, person);
                            }
                            : null, // Disable button if limits are exceeded
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: const Text(
                      'Save Preferences',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
