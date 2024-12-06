import 'package:get_it/get_it.dart';
import 'package:recepies_app/layers/data/meals_repository_imp.dart';
import 'package:recepies_app/layers/data/source/api/api.dart';
import 'package:recepies_app/layers/data/source/cache/meals_cache.dart';
import 'package:recepies_app/layers/data/source/local/local_hive.dart';
import 'package:recepies_app/layers/domain/repository/meals_repository.dart';
import 'package:recepies_app/layers/domain/usecase/added_check_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/get_categories_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/get_meal_details_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/get_meal_search_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/get_meals_by_area_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/get_meals_by_category_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/get_saved_meals_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/get_saved_recepies_by_id_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/remove_saved_recepie_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/save_recepie_usecase.dart';

GetIt getIt = GetIt.instance;

Future<void> initializeGetIt() async {
  // ---------------------------------------------------------------------------
  // DATA Layer
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<Api>(() => ApiImpl());
  getIt.registerLazySingleton<MealsCache>(() => MealsCache());
  getIt.registerLazySingleton<RecepiesLocal>(() => RecepiesLocalImpl());
  

  getIt.registerFactory<MealsRepository>(
    () => MealsRepositoryImpl(
      api: getIt(),
      mealsCache: getIt(),
      recepiesLocal: getIt()
    ),
  );

  // ---------------------------------------------------------------------------
  // DOMAIN Layer
  // ---------------------------------------------------------------------------
  getIt.registerFactory(
    () => GetMealsByArea(
      repository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => GetMealDetails(
      repository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => GetCategories(
      repository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => GetMealSearch(
      repository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => GetMealsByCategory(
      repository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => GetSavedMeals(
      repository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => SaveRecepie(
      repository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => AddCheck(
      repository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => RemoveRecepie(
      repository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => GetSavedMealsById(
      repository: getIt(),
    ),
  );

  // ---------------------------------------------------------------------------
  // PRESENTATION Layer
  // ---------------------------------------------------------------------------
  
}
