class Person {
  String name;
  List<String> allergens;
  List<String> preferences;
  List<String> avoidances;
  List<String> days;

  Person({
    required this.name,
    List<String>? allergens, 
    List<String>? preferences,
    List<String>? avoidances,
    List<String>? days,
  }) : allergens = allergens ?? [], // If null, initialize with an empty list
       preferences = preferences ?? [],
       avoidances = avoidances ?? [],
       days =
           days ??
           [
             'Monday',
             'Tuesday',
             'Wednesday',
             'Thursday',
             'Friday',
             'Saturday',
             'Sunday',
           ];
}
