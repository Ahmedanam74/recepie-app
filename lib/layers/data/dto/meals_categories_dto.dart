import 'dart:convert';

import 'package:recepies_app/layers/domain/entity/meal_categories_entity.dart';

class CategoriesDto extends Categories{
  CategoriesDto({
    super.idCategory,
    super.strCategory,
    super.strCategoryDescription,
    super.strCategoryThumb
  });
  factory CategoriesDto.fromRawJson(String str) =>
      CategoriesDto.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory CategoriesDto.fromMap(Map<String, dynamic> json) => CategoriesDto(
        idCategory: json['idCategory'],
        strCategory: json['strCategory'],
        strCategoryDescription: json['strCategoryDescription'],
        strCategoryThumb: json['strCategoryThumb'],
      );

  Map<String, dynamic> toMap() => {
        'idCategory': idCategory,
        'strCategory': strCategory,
        'strCategoryDescription': strCategoryDescription,
        'strCategoryThumb': strCategoryThumb,
      };
}