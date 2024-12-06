import 'package:recepies_app/layers/domain/entity/meals_entity.dart';
import 'package:recepies_app/layers/domain/repository/meals_repository.dart';

class GetMealsByArea {
  GetMealsByArea({
    required MealsRepository repository,
  }) : _repository = repository;

  final MealsRepository _repository;

  Future<List<Meals>> call({String a="Canadian"}) async {
    final list = await _repository.getMealsByArea(a: a);
    return list;
  }
}