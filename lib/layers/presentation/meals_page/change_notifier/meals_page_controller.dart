import 'package:flutter/material.dart';
import 'package:recepies_app/layers/domain/entity/meals_entity.dart';
import 'package:recepies_app/layers/domain/usecase/get_meals_by_area_usecase.dart';

enum MealsPageStatus { initial, loading, success, failed }

class MealsPageNotifier extends ChangeNotifier {
  MealsPageNotifier(
      {required GetMealsByArea getMealsByArea,
      // required HomePageNotifier homePageNotifier,
      List<Meals>? meals,
      MealsPageStatus? initialStatus})
      : _getMealsByArea = getMealsByArea,
        _meals = meals ?? [],
        _status = initialStatus ?? MealsPageStatus.initial;
  //       _homePageNotifier = homePageNotifier {
  //   fetchMeals();
  // }

  final GetMealsByArea _getMealsByArea;
  // final HomePageNotifier _homePageNotifier;
  MealsPageStatus _status;
  MealsPageStatus get status => _status;
  final List<Meals> _meals;
  String _country = "Canadian";
  String get country => _country;
  List<Meals> get meals => _meals;

  Future<void> fetchMeals() async {
    _meals.clear();
    // print("${_homePageNotifier.connectionStatus}======");
    _status = MealsPageStatus.loading;
    notifyListeners();

    final list = await _getMealsByArea(a: _country);
    _meals.addAll(list);
    if (_meals.isEmpty) {
      _status = MealsPageStatus.failed;
      notifyListeners();
    } else {
      _status = MealsPageStatus.success;
      notifyListeners();
    }
  }

  changeCountry(String selectedCountry) {
    _country = selectedCountry;
    notifyListeners();
  }

  
}
