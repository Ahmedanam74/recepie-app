import 'package:recepies_app/layers/domain/repository/meals_repository.dart';

class AddCheck {
  AddCheck({
    required MealsRepository repository,
  }) : _repository = repository;

  final MealsRepository _repository;

  Future<int> call(String p) async {
    return await _repository.addedCheck(p);
  }
}
