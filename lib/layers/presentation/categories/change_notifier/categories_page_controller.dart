import 'package:flutter/material.dart';
import 'package:recepies_app/layers/domain/entity/meal_categories_entity.dart';
import 'package:recepies_app/layers/domain/usecase/get_categories_usecase.dart';

enum CategoriesPageStatus { initial, loading, success, failed }

class CategoriesPageNotifier extends ChangeNotifier {
  CategoriesPageNotifier(
      {required GetCategories getCategories,
      List<Categories>? categories,
      CategoriesPageStatus? initialStatus})
      : _getCategories = getCategories,
        _categories = categories ?? [],
        _status = initialStatus ?? CategoriesPageStatus.initial;

  final GetCategories _getCategories;
  CategoriesPageStatus _status;
  CategoriesPageStatus get status => _status;
  final List<Categories> _categories;
  List<Categories> get categories => List.unmodifiable(_categories);

  Future<void> fetchCategories(BuildContext ctx) async {
    _categories.clear();
    _status = CategoriesPageStatus.loading;
    if (ctx.mounted) {
      notifyListeners();
    }
    final list = await _getCategories();
    _categories.addAll(list);
    if (_categories.isEmpty) {
      _status = CategoriesPageStatus.failed;
    } else {
      _status = CategoriesPageStatus.success;
    }
    // mounted
    if (ctx.mounted) {
      notifyListeners();
    }
  }
}
