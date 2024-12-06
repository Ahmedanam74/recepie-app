import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';

class MealsCache {
  final _cache = <String, MealDetails>{};

  MealDetails? get(String term) => _cache[term];

  void set(String term, MealDetails result) => _cache[term] = result;

  bool contains(String term) => _cache.containsKey(term);

  void remove(String term) => _cache.remove(term);
}