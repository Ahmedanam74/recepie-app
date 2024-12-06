import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';
import 'package:recepies_app/layers/domain/repository/meals_repository.dart';

class GetSavedMeals {
  GetSavedMeals({
    required MealsRepository repository,
  }) : _repository = repository;

  final MealsRepository _repository;

  Future<List<MealDetails>> call() async {
    final list = await _repository.getSavedRecepies();
    return list;
  }
}
