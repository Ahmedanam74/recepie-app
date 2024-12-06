import 'package:recepies_app/layers/domain/entity/meal_categories_entity.dart';
import 'package:recepies_app/layers/domain/repository/meals_repository.dart';

class GetCategories {
  GetCategories({
    required MealsRepository repository,
  }) : _repository = repository;

  final MealsRepository _repository;

  Future<List<Categories>> call() async {
    final list = await _repository.getCategories();
    return list;
  }
}