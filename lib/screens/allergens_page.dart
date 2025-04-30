import 'package:flutter/material.dart';
import 'package:neurodiner/widgets/dynamic_app_bar.dart';
import '../constants/constants.dart';
import '../models/person.dart';

class AllergensPage extends StatefulWidget {
  const AllergensPage({super.key});

  @override
  State<AllergensPage> createState() => _AllergensPageState();
}

class _AllergensPageState extends State<AllergensPage> {
  late List<bool> isBlocked;
  late Person person;

  @override
  void initState() {
    super.initState();
    isBlocked = List<bool>.filled(allergenNames.length, false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Grab the person from the route arguments
    person = ModalRoute.of(context)!.settings.arguments as Person;

    // Pre-select allergens that are already blocked for the person
    for (int i = 0; i < allergenNames.length; i++) {
      if (person.allergens.contains(allergenNames[i])) {
        isBlocked[i] = true;
      }
    }
  }

/// Toggle the allergen selection
  void _toggleAllergen(int index) {
    setState(() {
      isBlocked[index] = !isBlocked[index];
      if (isBlocked[index]) {
        person.allergens.add(allergenNames[index]);
      } else {
        person.allergens.remove(allergenNames[index]);
      }
    });
  }

/// Reset all allergens to unblocked
  void _resetAllergens() {
    setState(() {
      isBlocked = List<bool>.filled(allergenNames.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        title: 'Allergens for ${person.name}',
        showHelpButton: true,
        showSettingsButton: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allergenNames.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                final isSelected = isBlocked[index];

                return Tooltip(
                  message:
                      isSelected
                          ? 'Remove ${allergenNames[index]}'
                          : 'Block ${allergenNames[index]}',
                  child: ElevatedButton(
                    onPressed: () => _toggleAllergen(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected ? Colors.grey.shade300 : Colors.white,
                      foregroundColor: Colors.black,
                      side: BorderSide(
                        color: isSelected ? Colors.red : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logos/${allergenNames[index]}.png',
                              height: 48,
                              width: 48,
                            ),
                            const SizedBox(width: 8),
                            Text(allergenNames[index]),
                          ],
                        ),
                        if (isSelected)
                          Positioned(
                            right: 0,
                            child: Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 64,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 32.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: 'Reset all allergens to unblocked',
                    child: ElevatedButton(
                      onPressed: _resetAllergens,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                          double.infinity,
                          60,
                        ),
                      ),
                      child: const Text(
                        'Reset Allergens',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Tooltip(
                    message: 'Save selected allergens and return',
                    child: ElevatedButton(
                      onPressed: () {
                        // Return the updated person to the PeoplePage
                        Navigator.pop(context, person);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                          double.infinity,
                          60,
                        ),
                      ),
                      child: const Text(
                        'Save Allergens',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
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
