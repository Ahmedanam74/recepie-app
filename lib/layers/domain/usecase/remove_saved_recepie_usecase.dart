import 'package:dartz/dartz.dart';
import 'package:recepies_app/layers/domain/repository/meals_repository.dart';

class RemoveRecepie {
  RemoveRecepie({
    required MealsRepository repository,
  }) : _repository = repository;

  final MealsRepository _repository;

  Future<Unit> call(String idMeal) async {
    return await _repository.removeSavedRecepie(idMeal);
    
  }
}