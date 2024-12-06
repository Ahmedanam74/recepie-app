import 'dart:async'; // For debounce
import 'package:flutter/material.dart';
import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';
import 'package:recepies_app/layers/domain/usecase/get_meal_search_usecase.dart';

enum SearchPageStatus { initial, loading, success, failed, empty }

class SearchPageNotifier extends ChangeNotifier {
  SearchPageNotifier(
      {required GetMealSearch getMealSearch,
      List<MealDetails>? mealDetails,
      SearchPageStatus? initialStatus})
      : _getMealSearch = getMealSearch,
        _mealDetails = mealDetails ?? [],
        _status = initialStatus ?? SearchPageStatus.empty;

  final GetMealSearch _getMealSearch;
  SearchPageStatus _status;
  SearchPageStatus get status => _status;

  final List<MealDetails> _mealDetails;
  List<MealDetails> get mealDetails => _mealDetails;

  bool _showTextField = false;
  bool get showTextField => _showTextField;

  Timer? _debounce;

  Future<void> fetchMealDetails(String text) async {
    // Debounce logic to mimic event transformer behavior
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      _mealDetails.clear();

      if (text.isEmpty) {
        _status = SearchPageStatus.empty;
        notifyListeners();
        return;
      }

      _status = SearchPageStatus.loading;
      notifyListeners();

      try {
        final list = await _getMealSearch(mealName: text);
        _mealDetails.addAll(list);
        _status = SearchPageStatus.success;

        // for (var i = 0; i < _mealDetails.length; i++) {
        //   print(_mealDetails.length);
        //   print("${_mealDetails[i].strMeal}===========");
        // }

        notifyListeners();
      } catch (e) {
        _status = SearchPageStatus.failed;
        notifyListeners();
      }
    });
    // _status = SearchPageStatus.loading;
    // notifyListeners();
    // final list = await _getMealSearch(mealName: text);
    // _mealDetails.addAll(list);
    // _status = SearchPageStatus.success;

    // print("${_mealDetails[0].idMeal}===========");
    // print("${_mealDetails[0].ingredients}===========");
    // print("${_mealDetails[0].measures}===========");

    // notifyListeners();
  }

  void show() {
    _showTextField = !_showTextField;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
