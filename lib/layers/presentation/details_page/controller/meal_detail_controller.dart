import 'package:flutter/foundation.dart';
import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';
import 'package:recepies_app/layers/domain/usecase/added_check_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/get_meal_details_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/get_saved_recepies_by_id_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/remove_saved_recepie_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/save_recepie_usecase.dart';

enum DetailPageStatus { initial, loading, success, failed }

enum DetailPageSaveStatus { initial, loading, success, failed }

enum FetchMethod { local, global }

class MealDetailNotifier extends ChangeNotifier {
  MealDetailNotifier({
    required this.id,
    required GetMealDetails getMealDetails,
    required RemoveRecepie removeRecepie,
    required SaveRecepie saveRecepies,
    required GetSavedMealsById getSavedMealsById,
    required AddCheck addCheck,
    required FetchMethod fetchMethod,
    List<MealDetails>? mealDetails,
    DetailPageStatus? initialStatus,
    DetailPageSaveStatus? initialSaveStatus,
  })  : _getMealDetails = getMealDetails,
        _mealDetails = mealDetails ?? [],
        _status = initialStatus ?? DetailPageStatus.initial,
        _saveStatus = initialSaveStatus ?? DetailPageSaveStatus.initial,
        _saveRecepie = saveRecepies,
        _addCheck = addCheck,
        _getSavedMealsById = getSavedMealsById,
        _fetchMethod = fetchMethod,
        _removeRecepie = removeRecepie;

  final String id;
  int _result = -1;
  final RemoveRecepie _removeRecepie;
  final GetMealDetails _getMealDetails;
  final GetSavedMealsById _getSavedMealsById;
  final SaveRecepie _saveRecepie;
  final AddCheck _addCheck;
  DetailPageStatus _status;
  DetailPageSaveStatus _saveStatus;
  final FetchMethod _fetchMethod;
  DetailPageStatus get status => _status;
  int get result => _result;
  DetailPageSaveStatus get saveStatus => _saveStatus;
  final List<MealDetails> _mealDetails;
  List<MealDetails> get mealDetails => _mealDetails;

  fetchRecepiesDetails() {
    if (_fetchMethod == FetchMethod.global) {
      fetchMealDetails();
    } else {
      getSavedRecepies(id);
    }
  }

  Future<void> fetchMealDetails() async {
    _mealDetails.clear();

    _status = DetailPageStatus.loading;
    notifyListeners();

    final list = await _getMealDetails(id: id);
    _mealDetails.addAll(list);
    checkAdded();
    _status = DetailPageStatus.success;
    notifyListeners();
  }

  Future<void> getSavedRecepies(String idMeal) async {
    _mealDetails.clear();

    _status = DetailPageStatus.loading;
    notifyListeners();

    final list = await _getSavedMealsById(idMeal);
    _mealDetails.addAll(list);
    checkAdded();
    _status = DetailPageStatus.success;
    notifyListeners();
  }

  Future<void> saveRecepie() async {
    _saveStatus = DetailPageSaveStatus.loading;
    notifyListeners();
    final result = await _saveRecepie.call(mealDetails[0]);
    checkAdded();
    print(result);
  }

  Future<void> checkAdded() async {
    final result = await _addCheck.call(mealDetails[0].idMeal!);
    if (result == -1) {
      _result = -1;
      notifyListeners();
    } else {
      _result = result;
      notifyListeners();
    }
    print(_result);
  }

  Future<void> removeSavedRecepie(String idMeal) async {
    _saveStatus = DetailPageSaveStatus.loading;
    notifyListeners();

    final result = await _removeRecepie(idMeal);
    print(result);
    checkAdded();
    _saveStatus = DetailPageSaveStatus.success;
    notifyListeners();
  }
}
