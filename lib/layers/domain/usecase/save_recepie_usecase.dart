import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';
import 'package:recepies_app/layers/domain/repository/meals_repository.dart';

class SaveRecepie {
  SaveRecepie({
    required MealsRepository repository,
  }) : _repository = repository;

  final MealsRepository _repository;

  Future<int> call(MealDetails mealsDetails) async {
    return await _repository.saveRecepie(mealsDetails);
    
  }
}