import 'package:flutter/material.dart';
import 'package:neurodiner/widgets/dynamic_app_bar.dart';
import '../constants/constants.dart';
import '../models/person.dart';

class DaysPage extends StatefulWidget {
  const DaysPage({super.key});

  @override
  State<DaysPage> createState() => _DaysPageState();
}

class _DaysPageState extends State<DaysPage> {
  late List<bool> isEating;
  late Person person;

  @override
  void initState() {
    super.initState();
    isEating = List<bool>.filled(dayNames.length, true); // Default all to true (eating)
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    person = ModalRoute.of(context)!.settings.arguments as Person;

    if (person.days.isEmpty) {
      person.days.addAll(dayNames);
    }

    for (int i = 0; i < dayNames.length; i++) {
      isEating[i] = person.days.contains(dayNames[i]);
    }
  }

  void _toggleDay(int index) {
    setState(() {
      isEating[index] = !isEating[index];
      if (isEating[index]) {
        person.days.add(dayNames[index]);
      } else {
        person.days.remove(dayNames[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        title: 'Eating for ${person.name}',
        showHelpButton: true,
        showSettingsButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Loop through all days of the week and create a toggle switch for each
            for (int i = 0; i < dayNames.length; i++)
              _buildPreferenceTile(dayNames[i], isEating[i], () => _toggleDay(i)),
            ElevatedButton(
              onPressed: () {
                // Save preferences and return to the previous screen or apply filters
                Navigator.pop(context, person);
              },
              child: const Text(
                      'Save Days',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom method to build the toggle switch for each day
  Widget _buildPreferenceTile(String label, bool value, VoidCallback onChanged) {
    return SwitchListTile(
      title: Text(label),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      value: value,
      onChanged: (_) => onChanged(),  // Toggle day when switch is flipped
      activeColor: Colors.green,
      inactiveThumbColor: Colors.red,
    );
  }
}
