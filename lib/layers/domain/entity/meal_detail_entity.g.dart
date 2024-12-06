// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealDetailsAdapter extends TypeAdapter<MealDetails> {
  @override
  final int typeId = 1;

  @override
  MealDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealDetails(
      idMeal: fields[0] as String?,
      strMeal: fields[1] as String?,
      strDrinkAlternate: fields[2] as String?,
      strCategory: fields[3] as String?,
      strArea: fields[4] as String?,
      strInstructions: fields[5] as String?,
      strMealThumb: fields[6] as String?,
      strTags: fields[7] as String?,
      strYoutube: fields[8] as String?,
      ingredients: (fields[9] as List?)?.cast<String>(),
      measures: (fields[10] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MealDetails obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.idMeal)
      ..writeByte(1)
      ..write(obj.strMeal)
      ..writeByte(2)
      ..write(obj.strDrinkAlternate)
      ..writeByte(3)
      ..write(obj.strCategory)
      ..writeByte(4)
      ..write(obj.strArea)
      ..writeByte(5)
      ..write(obj.strInstructions)
      ..writeByte(6)
      ..write(obj.strMealThumb)
      ..writeByte(7)
      ..write(obj.strTags)
      ..writeByte(8)
      ..write(obj.strYoutube)
      ..writeByte(9)
      ..write(obj.ingredients)
      ..writeByte(10)
      ..write(obj.measures);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
