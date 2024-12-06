import 'package:flutter/foundation.dart';
import 'package:recepies_app/layers/domain/entity/meals_entity.dart';
import 'package:recepies_app/layers/domain/usecase/get_meals_by_category_usecase.dart';

enum MealsByCateoryPageStatus { initial, loading, success, failed }

class MealsByCategoryNotifier extends ChangeNotifier {
  MealsByCategoryNotifier(
      {required this.c,
      required GetMealsByCategory getMealsByCategory,
      List<Meals>? mealsbyCategory,
      MealsByCateoryPageStatus? initialStatus})
      : _getMealsByCategory = getMealsByCategory,
        _mealsByCategory = mealsbyCategory ?? [],
        _status = initialStatus ?? MealsByCateoryPageStatus.initial;

  final String c;

  final GetMealsByCategory _getMealsByCategory;
  MealsByCateoryPageStatus _status;
  MealsByCateoryPageStatus get status => _status;
  final List<Meals> _mealsByCategory;
  List<Meals> get mealsbyCategory => _mealsByCategory;

  Future<void> fetchMealsByCategory() async {
    _mealsByCategory.clear();

    _status = MealsByCateoryPageStatus.loading;
    notifyListeners();

    final list = await _getMealsByCategory(c: c);
    _mealsByCategory.addAll(list);
    if (_mealsByCategory.isEmpty) {
      _status = MealsByCateoryPageStatus.failed;
      notifyListeners();
    } else {
      _status = MealsByCateoryPageStatus.success;
      notifyListeners();
    }
  }
}
