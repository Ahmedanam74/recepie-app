import 'dart:convert';

import 'package:recepies_app/layers/domain/entity/meals_entity.dart';

class MealsDto extends Meals {
  MealsDto({
    super.idMeal,
    super.strMeal,
    super.strMealThumb,
  });
  factory MealsDto.fromRawJson(String str) =>
      MealsDto.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory MealsDto.fromMap(Map<String, dynamic> json) => MealsDto(
        strMeal: json['strMeal'],
        strMealThumb: json['strMealThumb'],
        idMeal: json['idMeal'],
      );

  Map<String, dynamic> toMap() => {
        'strMeal': strMeal,
        'strMealThumb': strMealThumb,
        'idMeal': idMeal,
      };
}
