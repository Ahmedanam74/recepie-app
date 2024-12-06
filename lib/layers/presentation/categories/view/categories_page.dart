import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:recepies_app/layers/core/constants/svg_pictures.dart';
import 'package:recepies_app/layers/domain/entity/meal_categories_entity.dart';
import 'package:recepies_app/layers/domain/usecase/get_categories_usecase.dart';
import 'package:recepies_app/layers/injector.dart';
import 'package:recepies_app/layers/presentation/categories/change_notifier/categories_page_controller.dart';
import 'package:recepies_app/layers/presentation/meals_by_category/view/meals_by_category_page.dart';
import 'package:recepies_app/layers/presentation/search_page/view/search_page.dart';
import 'package:recepies_app/layers/presentation/shared/widgets/no_internet_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final useCase = getIt<GetCategories>();
    return ChangeNotifierProvider(
      create: (_) => CategoriesPageNotifier(getCategories: useCase),
      child: const CategoriesView(),
    );
  }
}

class CategoriesView extends StatefulWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesPageNotifier>().fetchCategories(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select((CategoriesPageNotifier c) => c.status);
    if (status == CategoriesPageStatus.initial ||
        status == CategoriesPageStatus.loading) {
      return const _Content(
        enabled: true,
      );
    }
    if (status == CategoriesPageStatus.failed) {
      return NoInternetWidget(
        onPressed: () {
          context.read<CategoriesPageNotifier>().fetchCategories(context);
        },
      );
    }
    return const _Content(
      enabled: false,
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key, required this.enabled}) : super(key: key);
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final list = context.select((CategoriesPageNotifier c) => c.categories);
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Search",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SearchPage(),
              ));
            },
            child: Container(
              color: Colors.white,
              height: size.height * .07,
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppSvg.search,
                    width: size.width * .06,
                    colorFilter: const ColorFilter.mode(
                        Color(0xFFbfbfbf), BlendMode.srcIn),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "Search any recipes",
                    style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFFbfbfbf),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Browse all",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          enabled == true
              ? Expanded(
                  child: Skeletonizer(
                    child: GridView.builder(
                      itemCount: 10,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        return const Card(
                          elevation: 0,
                          child: SizedBox(
                            width: 170,
                            height: 160,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10, // Space between items horizontally
                      runSpacing: 10, // Space between rows
                      children: list
                          .map((category) => CategoriesListItem(
                                size: size,
                                categories: category,
                                onTap: () {
                                  Navigator.of(context).push(
                                      MealsByCategoryPage.route(
                                          c: category.strCategory!));
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class CategoriesListItem extends StatelessWidget {
  const CategoriesListItem({
    super.key,
    required this.categories,
    this.onTap,
    required this.size,
  });

  final Categories categories;
  final void Function()? onTap;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: size.width * .42,
        height: size.height * .2,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Image on the card
              CachedNetworkImage(
                height: double.infinity,
                width: double.infinity,
                imageUrl: categories.strCategoryThumb!,
                fit: BoxFit.cover,
                errorWidget: (ctx, url, err) => const Icon(Icons.error),
                placeholder: (ctx, url) => const Icon(Icons.image),
              ),
              // Semi-transparent overlay for the text
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              // Positioned text on top of the image
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  categories.strCategory!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
