import 'package:dartz/dartz.dart';
import 'package:recepies_app/layers/domain/entity/meal_categories_entity.dart';
import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';
import 'package:recepies_app/layers/domain/entity/meals_entity.dart';

abstract class MealsRepository {
  Future<List<Meals>> getMealsByArea({String a = "Canadian"});
  Future<List<MealDetails>> getMealDetails({String id = "52772"});
  Future<List<MealDetails>> getMealSearch({String mealName = "Arrabiata"});
  Future<List<Categories>> getCategories();
  Future<List<Meals>> getMealsByCategory({String c = "Seafood"});
  Future<List<MealDetails>> getSavedRecepies();
  Future<List<MealDetails>> getRecipeById(String idMeal);
  Future<Unit> removeSavedRecepie(String idMeal);
  Future<int> saveRecepie(MealDetails item);
  Future<int> addedCheck(String p);
}
