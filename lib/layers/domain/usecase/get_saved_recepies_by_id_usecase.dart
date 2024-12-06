import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';
import 'package:recepies_app/layers/domain/repository/meals_repository.dart';

class GetSavedMealsById {
  GetSavedMealsById({
    required MealsRepository repository,
  }) : _repository = repository;

  final MealsRepository _repository;

  Future<List<MealDetails>> call(String idMeal) async {
    final list = await _repository.getRecipeById(idMeal);
    return list;
  }
}
