import 'package:hive_flutter/hive_flutter.dart';
import 'package:recepies_app/layers/data/dto/meals_detail_dto.dart';

abstract class RecepiesLocal {
  Future<List<MealDetailDto>> getRecepies();
  Future<int> addRecepie(MealDetailDto item);
  Future<void> removeSavedRecepie(String idMeal);
  Future<int> isItemAdded(String tmdbID);
  Future<List<MealDetailDto>> getRecipeById(String idMeal);
}

class RecepiesLocalImpl extends RecepiesLocal {
  final Box _box = Hive.box('recepies');

  @override
  Future<List<MealDetailDto>> getRecepies() async {
    return _box.values
        .map((e) => MealDetailDto.fromEntity(e))
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<int> addRecepie(MealDetailDto item) async {
    return await _box.add(item);
  }

  @override
  Future<void> removeSavedRecepie(String idMeal) async {
    int index =
        _box.values.toList().indexWhere((meal) => meal.idMeal == idMeal);
    await _box.deleteAt(index);
  }

  @override
  Future<int> isItemAdded(String idMeal) async {
    return _box.values.toList().indexWhere((e) => e.idMeal == idMeal);
  }

  @override
  Future<List<MealDetailDto>> getRecipeById(String idMeal) async {
    return _box.values
        .where((e) => e.idMeal == idMeal) // Filter by idMeal
        .map((e) => MealDetailDto.fromEntity(e))
        .toList()
        .reversed
        .toList();
  }
}
