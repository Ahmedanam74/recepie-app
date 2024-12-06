import 'package:flutter/foundation.dart';
import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';
import 'package:recepies_app/layers/domain/usecase/get_saved_meals_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/remove_saved_recepie_usecase.dart';

enum SavedRecepiesStatus { initial, loading, success, failed, deleted, empty }

class SavedRecepiesNotifier extends ChangeNotifier {
  SavedRecepiesNotifier({
    required GetSavedMeals getSavedMeals,
    required RemoveRecepie removeRecepie,
    List<MealDetails>? mealDetails,
    SavedRecepiesStatus? initialStatus,
  })  : _getSavedMeals = getSavedMeals,
        _mealDetails = mealDetails ?? [],
        _status = initialStatus ?? SavedRecepiesStatus.initial,
        _removeRecepie = removeRecepie;

  final GetSavedMeals _getSavedMeals;
  final RemoveRecepie _removeRecepie;
  SavedRecepiesStatus _status;
  SavedRecepiesStatus get status => _status;
  final List<MealDetails> _mealDetails;
  List<MealDetails> get mealDetails => _mealDetails;

  Future<void> getSavedRecepies() async {
    _mealDetails.clear();

    _status = SavedRecepiesStatus.loading;
    notifyListeners();

    final list = await _getSavedMeals();
    _mealDetails.addAll(list);
    if (_mealDetails.isEmpty) {
      _status = SavedRecepiesStatus.empty;
      notifyListeners();
    } else {
      _status = SavedRecepiesStatus.success;
      notifyListeners();
    }
  }

  Future<void> removeSavedRecepie(String idMeal) async {
    // _status = SavedRecepiesStatus.loading;
    // notifyListeners();

    final result = await _removeRecepie(idMeal);
    print(result);
    // mealDetails.removeWhere((meal) => meal.idMeal == idMeal);
    getSavedRecepies();
    // _status = SavedRecepiesStatus.success;
    // notifyListeners();
  }
}
