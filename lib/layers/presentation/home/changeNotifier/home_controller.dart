import 'package:flutter/material.dart';
import 'package:recepies_app/layers/presentation/meals_page/view/meals_page.dart';
import 'package:recepies_app/layers/presentation/saved_meals/view/saved_recepies_view.dart';
import 'package:recepies_app/layers/presentation/categories/view/categories_page.dart';

enum ConnectionStatus { initial, connected, notConnected }

class HomePageNotifier extends ChangeNotifier {
  int page = 0;
  List<Widget> pages = [const MealsPage(), const CategoriesPage(), const SavedRecepiesPage()];


  changePage(int index) {
    page = index;
    notifyListeners();
  }

}
