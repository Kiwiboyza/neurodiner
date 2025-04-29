import 'package:flutter/material.dart';
import 'package:neurodiner/providers/people_provider.dart';
import 'package:provider/provider.dart';
import 'package:neurodiner/widgets/dynamic_app_bar.dart';
import 'package:neurodiner/functions/functions.dart';
import 'package:neurodiner/models/person.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  PeoplePageState createState() => PeoplePageState();
}

class PeoplePageState extends State<PeoplePage> {
  // List of controllers for each person
  final List<TextEditingController> _controllers = [];

  // Method to add a new person
  void _addNewPerson(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context, listen: false);
    final newPersonName = 'User ${peopleProvider.people.length + 1}';
    peopleProvider.addPerson(Person(name: newPersonName));
    _controllers.add(TextEditingController());
  }

  void _removePerson(BuildContext context, int index) {
    final peopleProvider = Provider.of<PeopleProvider>(context, listen: false);
    peopleProvider.removePerson(index);
    _controllers.removeAt(index);
  }


  @override
  void dispose() {
    // Dispose all controllers when done
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final people = peopleProvider.people;

    return Scaffold(
      appBar: DynamicAppBar(
        title: "People",
        showHelpButton: true,
        showSettingsButton: true,
        showHomeButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Family',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Scrollable list of people
            ListView.builder(
              shrinkWrap: true,
              itemCount: people.length,
              itemBuilder: (context, index) {
                // Create a controller for each person if not already created
                if (_controllers.length <= index) {
                  _controllers.add(TextEditingController(text: people[index].name));
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: darkenColor(Theme.of(context).colorScheme.surface),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Name input field
                        TextField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            labelText: 'Name',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          onSubmitted: (value) {
                            if (value == '' || value.trim().isEmpty) {
                              _controllers[index].text = 'User ${index + 1}';
                              peopleProvider.updateName(index, 'User ${index + 1}');
                            }
                          },
                          onChanged: (value) => peopleProvider.updateName(index, value),
                        ),
                        const SizedBox(height: 8.0),
                        // Horizontal row with 4 buttons (Allergens, Preferences, Days, Remove)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/allergens', arguments: people[index]);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.black),
                                backgroundColor: darkenColor(Theme.of(context).colorScheme.surface),
                                foregroundColor: darkenColor(Theme.of(context).colorScheme.onSurface),
                              ),
                              child: const Text("Allergens"),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/preferences', arguments: people[index]);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.black), // Black border for the button
                                backgroundColor: darkenColor(Theme.of(context).colorScheme.surface),  // Darkened background
                                foregroundColor: darkenColor(Theme.of(context).colorScheme.onSurface), // Darkened text color
                              ),
                              child: const Text("Preferences"),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/days', arguments: people[index]);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.black), // Black border for the button
                                backgroundColor: darkenColor(Theme.of(context).colorScheme.surface),  // Darkened background
                                foregroundColor: darkenColor(Theme.of(context).colorScheme.onSurface), // Darkened text color
                              ),
                              child: const Text("Days"),
                            ),
                            OutlinedButton(
                              onPressed: () => _removePerson(context, index),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.black), // Black border for the button
                                backgroundColor: darkenColor(Theme.of(context).colorScheme.surface),  // Darkened background
                                foregroundColor: darkenColor(Theme.of(context).colorScheme.onSurface), // Darkened text color
                              ),
                              child: const Text("Remove"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 100),

            ElevatedButton(
              onPressed: () => _addNewPerson(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkenColor(Theme.of(context).colorScheme.surface),
                foregroundColor: darkenColor(Theme.of(context).colorScheme.onSurface),
                minimumSize: const Size(400, 100),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: const Text('Add New Person'),
            ),

            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                final personNames = people.map((person) => person.name).join(', ');
                print('Generating meal plan for: $personNames');
                print('Allergens: ${people.map((person) => person.allergens).toList()}');
                print('Preferences: ${people.map((person) => person.preferences).toList()}');
                print('Avoidances: ${people.map((person) => person.avoidances).toList()}');
                print('Days: ${people.map((person) => person.days).toList()}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkenColor(Theme.of(context).colorScheme.surface),
                foregroundColor: darkenColor(Theme.of(context).colorScheme.onSurface),
                minimumSize: const Size(400, 100),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: const Text('Generate your meal plan'),
            ),
          ],
        ),
      ),
    );
  }
}
