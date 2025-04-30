// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 0;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      id: fields[0] as String,
      name: fields[1] as String,
      categoryID: fields[2] as String,
      timeOfDay: fields[3] as String,
      allergens: (fields[4] as List).cast<String>(),
      sensoryTags: (fields[5] as List).cast<String>(),
      calories: fields[6] as int,
      notes: fields[7] as String,
      externalUrl: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.categoryID)
      ..writeByte(3)
      ..write(obj.timeOfDay)
      ..writeByte(4)
      ..write(obj.allergens)
      ..writeByte(5)
      ..write(obj.sensoryTags)
      ..writeByte(6)
      ..write(obj.calories)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.externalUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
