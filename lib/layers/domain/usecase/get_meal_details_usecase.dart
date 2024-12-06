import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';
import 'package:recepies_app/layers/domain/repository/meals_repository.dart';

class GetMealDetails {
  GetMealDetails({
    required MealsRepository repository,
  }) : _repository = repository;

  final MealsRepository _repository;

  Future<List<MealDetails>> call({String id="52772"}) async {
    final list = await _repository.getMealDetails(id: id);
    return list;
  }
}