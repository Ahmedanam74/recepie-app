import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recepies_app/layers/domain/entity/meals_entity.dart';
import 'package:recepies_app/layers/domain/usecase/get_meals_by_category_usecase.dart';
import 'package:recepies_app/layers/injector.dart';
import 'package:recepies_app/layers/presentation/categories/change_notifier/categories_page_controller.dart';
import 'package:recepies_app/layers/presentation/details_page/controller/meal_detail_controller.dart';
import 'package:recepies_app/layers/presentation/details_page/view/meal_detail_view.dart';
import 'package:recepies_app/layers/presentation/meals_by_category/controller/meals_by_category_controller.dart';
import 'package:recepies_app/layers/presentation/shared/widgets/no_internet_widget.dart';

class MealsByCategoryPage extends StatelessWidget {
  const MealsByCategoryPage({Key? key}) : super(key: key);

  static Route<void> route({required String c}) {
    final useCase = getIt<GetMealsByCategory>();
    return MaterialPageRoute(
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) =>
              MealsByCategoryNotifier(c: c, getMealsByCategory: useCase),
          child: const MealsByCategoryPage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => const MealsByCategoryView();
}

class MealsByCategoryView extends StatefulWidget {
  const MealsByCategoryView({Key? key}) : super(key: key);

  @override
  State<MealsByCategoryView> createState() => _MealsByCategoryViewState();
}

class _MealsByCategoryViewState extends State<MealsByCategoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealsByCategoryNotifier>().fetchMealsByCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (MealsByCategoryNotifier cn) => cn.status,
    );
    if (status == MealsByCateoryPageStatus.initial ||
        status == MealsByCateoryPageStatus.loading) {
      return const _Content(
        // enabled: true,
      );
    }
    if (status == MealsByCateoryPageStatus.failed) {
      return NoInternetWidget(
        onPressed: () {
          context.read<CategoriesPageNotifier>().fetchCategories(context);
        },
      );
    }
    return const _Content(
      // enabled: false,
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final item = context.select(
      (MealsByCategoryNotifier cn) => cn.mealsbyCategory,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Wrap(
          spacing: 15, // Space between items horizontally
          runSpacing: 10, // Space between rows
          children: item
              .map((category) => CategoriesListItem(
                    meals: category,
                    onTap: () {
                      Navigator.of(context).push(MealDetailPage.route(
                          id: category.idMeal!,
                          fetchMethod: FetchMethod.global));
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class CategoriesListItem extends StatelessWidget {
  const CategoriesListItem({
    super.key,
    required this.meals,
    this.onTap,
  });

  final Meals meals;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 145,
        height: 210,
        child: Card(
          // color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            // Image on the card
            CachedNetworkImage(
              imageUrl: meals.strMealThumb!,
              fit: BoxFit.cover,
              errorWidget: (ctx, url, err) => const Icon(Icons.error),
              placeholder: (ctx, url) => const Icon(Icons.image),
            ),
            // Semi-transparent overlay for the text
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            //       begin: Alignment.bottomCenter,
            //       end: Alignment.topCenter,
            //     ),
            //   ),
            // ),
            // Positioned text on top of the image
            Text(
              meals.strMeal!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
