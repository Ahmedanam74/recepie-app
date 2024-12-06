
import 'package:equatable/equatable.dart';

class Meals with EquatableMixin {
  Meals({
    this.idMeal,
    this.strMeal,
    this.strMealThumb,
  });
  String? strMeal;
  String? strMealThumb;
  String? idMeal;
  
  @override
  // TODO: implement props
  List<Object?> get props => [strMeal,strMealThumb,strMealThumb];

  
}