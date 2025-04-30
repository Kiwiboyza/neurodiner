import 'package:flutter/material.dart';
import 'package:neurodiner/models/person.dart';

class PeopleProvider extends ChangeNotifier {
  final List<Person> _people = [];

  List<Person> get people => _people;

  void addPerson(Person person) {
    _people.add(person);
    notifyListeners();
  }

  void removePerson(int index) {
    _people.removeAt(index);
    notifyListeners();
  }

  void updateName(int index, String newName) {
    _people[index].name = newName;
    notifyListeners();
  }

  // Method to update allergens for a specific person
  void updateAllergens(int index, List<String> newAllergens) {
    _people[index].allergens = newAllergens;
    notifyListeners();
  }

  // Method to update preferences for a specific person
  void updatePreferences(int index, List<String> newPreferences) {
    _people[index].preferences = newPreferences;
    notifyListeners();
  }

  // Method to update days for a specific person
  void updateDays(int index, List<String> newDays) {
    _people[index].days = newDays;
    notifyListeners();
  }
}
