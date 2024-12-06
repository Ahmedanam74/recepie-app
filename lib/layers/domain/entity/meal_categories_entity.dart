import 'package:equatable/equatable.dart';

class Categories with EquatableMixin{
  String ?idCategory;
  String ?strCategory;
  String ?strCategoryThumb;
  String ?strCategoryDescription;

  Categories(
      {this.idCategory,
      this.strCategory,
      this.strCategoryThumb,
      this.strCategoryDescription});
      
        @override
        // TODO: implement propsid
        List<Object?> get props => [idCategory,strCategory,strCategoryThumb,strCategoryDescription];
}