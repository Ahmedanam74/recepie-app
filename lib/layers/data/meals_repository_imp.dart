import 'package:hive/hive.dart';
import 'package:recepies_app/layers/data/dto/meals_detail_dto.dart';
import 'package:recepies_app/layers/data/source/api/api.dart';
import 'package:recepies_app/layers/data/source/cache/meals_cache.dart';
import 'package:recepies_app/layers/data/source/local/local_hive.dart';
import 'package:recepies_app/layers/domain/entity/meal_categories_entity.dart';
import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';
import 'package:recepies_app/layers/domain/entity/meals_entity.dart';
import 'package:recepies_app/layers/domain/repository/meals_repository.dart';
import 'package:dartz/dartz.dart';

class MealsRepositoryImpl implements MealsRepository {
  final Api _api;
  final MealsCache _cache;
  final RecepiesLocal _recepiesLocal;

  MealsRepositoryImpl(
      {required Api api,
      required MealsCache mealsCache,
      required RecepiesLocal recepiesLocal})
      : _api = api,
        _cache = mealsCache,
        _recepiesLocal = recepiesLocal;

  @override
  Future<List<Meals>> getMealsByArea({String a = "Canadian"}) async {
    final fetchedList = await _api.getMealsByArea(a: a);
    return fetchedList;
  }

  @override
  Future<List<MealDetails>> getMealDetails({String id = "52772"}) async {
    final fetchedList = await _api.getMealDetails(id: id);
    return fetchedList;
  }

  @override
  Future<List<MealDetails>> getMealSearch(
      {String mealName = "Arrabiata"}) async {
    final cachedResult = _cache.get(mealName);
    if (cachedResult != null) {
      return [cachedResult];
    }
    final fetchedList = await _api.getMealSearch(mealName: mealName);
    return fetchedList;
  }

  @override
  Future<List<Categories>> getCategories() async {
    final fetchedList = await _api.getCategories();
    return fetchedList;
  }

  @override
  Future<List<Meals>> getMealsByCategory({String c = "Seafood"}) async {
    final fetchedList = await _api.getMealsByCategory();
    return fetchedList;
  }

  @override
  Future<int> saveRecepie(MealDetails item) async {
    try {
      int id = await _recepiesLocal.addRecepie(MealDetailDto.fromEntity(item));
      return id;
    } on HiveError catch (e) {
      print(e);
      return 0;
    }
  }

  @override
  Future<List<MealDetails>> getSavedRecepies() async {
    final result = (await _recepiesLocal.getRecepies());
    try {
      return result;
    } on HiveError catch (e) {
      print(e);
      return [];
    }
  }
  @override
  Future<List<MealDetails>> getRecipeById(String idMeal) async {
    final result = (await _recepiesLocal.getRecipeById(idMeal));
    try {
      return result;
    } on HiveError catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<int> addedCheck(String p) async {
    try {
      final result = await _recepiesLocal.isItemAdded(p);
      return result;
    } on HiveError catch (e) {
      print("$e===========");
      return 0;
    }
  }

  @override
  Future<Unit> removeSavedRecepie(String idMeal) async {
    try {
      await _recepiesLocal.removeSavedRecepie(idMeal);
      return unit;
    } on HiveError catch (e) {
      return unit;
    }
  }
}
