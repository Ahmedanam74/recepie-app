import 'dart:convert';
import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';

class MealDetailDto extends MealDetails {
  MealDetailDto({
    super.idMeal,
    super.strMeal,
    super.strDrinkAlternate,
    super.strCategory,
    super.strArea,
    super.strInstructions,
    super.strMealThumb,
    super.strTags,
    super.strYoutube,
    super.ingredients,
    super.measures,
  });
   factory MealDetailDto.fromEntity(MealDetails mealDetails) {
    return MealDetailDto(
      idMeal: mealDetails.idMeal,
      strMeal: mealDetails.strMeal,
      strDrinkAlternate: mealDetails.strDrinkAlternate,
      strCategory: mealDetails.strCategory,
      strArea: mealDetails.strArea,
      strInstructions: mealDetails.strInstructions,
      strMealThumb: mealDetails.strMealThumb,
      strTags: mealDetails.strTags,
      strYoutube: mealDetails.strYoutube,
      ingredients: mealDetails.ingredients,
      measures: mealDetails.measures,
    );
  }
  // Factory constructor to create a MealDetailDto from raw JSON string
  factory MealDetailDto.fromRawJson(String str) => MealDetailDto.fromMap(json.decode(str));

  // Convert MealDetailDto to raw JSON string
  String toRawJson() => json.encode(toMap());

  // Factory constructor to create a MealDetailDto from Map
  factory MealDetailDto.fromMap(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      String ingredient = json['strIngredient$i'] ?? '';
      if (ingredient.isNotEmpty) {
        ingredients.add(ingredient);
      }
      String measure = json['strMeasure$i'] ?? '';
      if (measure.isNotEmpty) {
        measures.add(measure);
      }
    }

    return MealDetailDto(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strDrinkAlternate: json['strDrinkAlternate'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      strTags: json['strTags'],
      strYoutube: json['strYoutube'],
      ingredients: ingredients,
      measures: measures,
    );
  }

  // Convert MealDetailDto to Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strDrinkAlternate': strDrinkAlternate,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
      'strTags': strTags,
      'strYoutube': strYoutube,
    };

    for (int i = 0; i < ingredients!.length; i++) {
      data['strIngredient${i + 1}'] = ingredients![i];
      data['strMeasure${i + 1}'] = measures![i];
    }

    return data;
  }
  
}
