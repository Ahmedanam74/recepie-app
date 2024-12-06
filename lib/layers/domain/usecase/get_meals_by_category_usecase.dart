import 'package:recepies_app/layers/domain/entity/meals_entity.dart';
import 'package:recepies_app/layers/domain/repository/meals_repository.dart';

class GetMealsByCategory {
  GetMealsByCategory({
    required MealsRepository repository,
  }) : _repository = repository;

  final MealsRepository _repository;

  Future<List<Meals>> call({String c="Seafood"}) async {
    final list = await _repository.getMealsByCategory(c: c);
    return list;
  }
}