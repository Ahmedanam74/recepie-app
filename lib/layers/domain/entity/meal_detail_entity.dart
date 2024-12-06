import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'meal_detail_entity.g.dart';
@HiveType(typeId: 1)
class MealDetails with EquatableMixin {
  @HiveField(0)
  final String? idMeal;
  @HiveField(1)
  final String? strMeal;
  @HiveField(2)
  final String? strDrinkAlternate;
  @HiveField(3)
  final String? strCategory;
  @HiveField(4)
  final String? strArea;
  @HiveField(5)
  final String? strInstructions;
  @HiveField(6)
  final String? strMealThumb;
  @HiveField(7)
  final String? strTags;
  @HiveField(8)
  final String? strYoutube;
  @HiveField(9)
  final List<String>? ingredients;
  @HiveField(10)
  final List<String>? measures;

  MealDetails({
    this.idMeal,
    this.strMeal,
    this.strDrinkAlternate,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.strYoutube,
    this.ingredients,
    this.measures,
  });

  @override
  List<Object?> get props => [
        idMeal,
        strMeal,
        strDrinkAlternate,
        strCategory,
        strArea,
        strInstructions,
        strMealThumb,
        strTags,
        strYoutube,
        ingredients,
        measures,
      ];
}
