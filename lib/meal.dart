import 'package:hive/hive.dart';

part 'meal.g.dart';

@HiveType(typeId: 0)
class Meal extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String category;

  @HiveField(3)
  late String timeOfDay;

  @HiveField(4)
  late List<String> allergens;

  @HiveField(5)
  late List<String> sensoryTags;

  @HiveField(6)
  late int calories;

  @HiveField(7)
  late String notes;

  @HiveField(8)
  late String externalUrl;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.timeOfDay,
    required this.allergens,
    required this.sensoryTags,
    required this.calories,
    required this.notes,
    required this.externalUrl,
  });

  factory Meal.fromCsv(List<dynamic> fields) {
    return Meal(
      id: fields[0].toString(),
      name: fields[1],
      category: fields[2],
      timeOfDay: fields[3],
      allergens: (fields[4] as String).isEmpty ? [] : fields[4].split(';'),
      sensoryTags: (fields[5] as String).isEmpty ? [] : fields[5].split(';'),
      calories: int.tryParse(fields[6].toString()) ?? 0,
      notes: fields[7] ?? '',
      externalUrl: fields[8] ?? '',
    );
  }
}