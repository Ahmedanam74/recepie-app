import 'package:dio/dio.dart';
import 'package:recepies_app/layers/data/dto/meals_categories_dto.dart';
import 'package:recepies_app/layers/data/dto/meals_detail_dto.dart';
import 'package:recepies_app/layers/data/dto/meals_dto.dart';

abstract class Api {
  Future<List<MealsDto>> getMealsByArea({String a = "Canadian"});
  Future<List<MealDetailDto>> getMealDetails({String id = "52772"});
  Future<List<MealDetailDto>> getMealSearch({String mealName = "Arrabiata"});
  Future<List<MealsDto>> getMealsByCategory({String c = "Seafood"});
  Future<List<CategoriesDto>> getCategories();
}

class ApiImpl implements Api {
  @override
  Future<List<MealsDto>> getMealsByArea({String a = "Canadian"}) async {
    final dio = Dio();
    try {
      Response response;
      response = await dio
          .get('https://www.themealdb.com/api/json/v1/1/filter.php?a=$a');

      final l = (response.data['meals'] as List)
          .map((e) => MealsDto.fromMap(e))
          .toList();
      return l;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);

        //  API responds with 404 when reached the end
        if (e.response?.statusCode == 404) return [];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    return [];
  }

  @override
  Future<List<MealDetailDto>> getMealDetails({String id = "52772"}) async {
    final dio = Dio();
    try {
      Response response;
      response =
          await dio.get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id');

      final l = (response.data['meals'] as List)
          .map((e) => MealDetailDto.fromMap(e))
          .toList();
      return l;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);

        //  API responds with 404 when reached the end
        if (e.response?.statusCode == 404) return [];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    return [];
  }
  @override
  Future<List<MealDetailDto>> getMealSearch({String mealName = "Arrabiata"}) async {
    final dio = Dio();
    try {
      Response response;
      response =
          await dio.get('https://www.themealdb.com/api/json/v1/1/search.php?s=$mealName');

      final l = (response.data['meals'] as List)
          .map((e) => MealDetailDto.fromMap(e))
          .toList();
      return l;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);

        //  API responds with 404 when reached the end
        if (e.response?.statusCode == 404) return [];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    return [];
  }
  @override
  Future<List<CategoriesDto>> getCategories() async {
    final dio = Dio();
    try {
      Response response;
      response =
          await dio.get('https://www.themealdb.com/api/json/v1/1/categories.php');

      final l = (response.data['categories'] as List)
          .map((e) => CategoriesDto.fromMap(e))
          .toList();
      return l;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);

        //  API responds with 404 when reached the end
        if (e.response?.statusCode == 404) return [];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    return [];
  }
  
  @override
  Future<List<MealsDto>> getMealsByCategory({String c = "Seafood"}) async{
    final dio = Dio();
    try {
      Response response;
      response =
          await dio.get('https://www.themealdb.com/api/json/v1/1/filter.php?c=$c');

      final l = (response.data['meals'] as List)
          .map((e) => MealsDto.fromMap(e))
          .toList();
      return l;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);

        //  API responds with 404 when reached the end
        if (e.response?.statusCode == 404) return [];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    return [];
    
  }
}
