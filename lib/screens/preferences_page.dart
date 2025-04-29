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

  void _togglePreference(int index, int state) {
    setState(() {
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

  void _resetPreferences() {
    setState(() {
      preferenceStates = List<int>.filled(preferenceNames.length, 0); // Reset all states to 0 (Neutral)
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: preferenceNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(preferenceNames[index]),
                  subtitle: Text(preferenceExamples[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.thumb_up,
                          color: preferenceStates[index] == 2 ? Colors.green : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () => _togglePreference(index, 2),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: preferenceStates[index] == 0 ? Colors.black : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () => _togglePreference(index, 0),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.thumb_down,
                          color: preferenceStates[index] == 1 ? Colors.red : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () => _togglePreference(index, 1),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // First button with reset action
                ElevatedButton(
                  onPressed: _resetPreferences,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60), // Optional: Larger button height
                  ),
                  child: const Text('Reset Preferences', style: TextStyle(color: Colors.black),),
                ),
                const SizedBox(height: 16),
                // Second button for going back to People page
                ElevatedButton(
                  onPressed: () {
                    // Return the updated person to the PeoplePage
                    Navigator.pop(context, person);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60), // Optional: Larger button height
                  ),
                  child: const Text(
                      'Save Preferences',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
