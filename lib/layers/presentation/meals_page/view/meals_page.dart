import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recepies_app/layers/core/constants/app_contstans.dart';
import 'package:recepies_app/layers/domain/entity/meals_entity.dart';
import 'package:recepies_app/layers/domain/usecase/get_meals_by_area_usecase.dart';
import 'package:recepies_app/layers/injector.dart';
import 'package:recepies_app/layers/presentation/details_page/controller/meal_detail_controller.dart';
import 'package:recepies_app/layers/presentation/details_page/view/meal_detail_view.dart';
import 'package:recepies_app/layers/presentation/meals_page/change_notifier/meals_page_controller.dart';
import 'package:recepies_app/layers/presentation/shared/widgets/customized_container.dart';
import 'package:recepies_app/layers/presentation/shared/widgets/no_internet_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final useCase = getIt<GetMealsByArea>();
    return ChangeNotifierProvider(
      create: (_) => MealsPageNotifier(getMealsByArea: useCase),
      child: MealsView(),
    );
  }
}

class MealsView extends StatefulWidget {
  const MealsView({Key? key}) : super(key: key);

  @override
  State<MealsView> createState() => _MealsViewState();
}

class _MealsViewState extends State<MealsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealsPageNotifier>().fetchMeals();
    });
  }

  // @override
  @override
  Widget build(BuildContext context) {
    final status = context.select((MealsPageNotifier c) => c.status);

    if (status == MealsPageStatus.initial ||
        status == MealsPageStatus.loading) {
      return const _Content(
        enabled: true,
      );
    }
    if (status == MealsPageStatus.failed) {
      return NoInternetWidget(
        onPressed: () {
          context.read<MealsPageNotifier>().fetchMeals();
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
    final list = context.select((MealsPageNotifier b) => b.meals);
    final _country = context.select((MealsPageNotifier b) => b.country);
    final theme = Theme.of(context).colorScheme;
    return Skeletonizer(
      enabled: enabled,
      enableSwitchAnimation: true,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "what would you like\nto cook today?",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Countries",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              runSpacing: 16.0,
              spacing: 16.0,
              children: [
                ...AppConstants.countries.map((country) => CustomizedContainer(
                      textColor: _country == country
                          ? theme.onPrimaryContainer
                          : theme.onSecondaryContainer,
                      svg: AppConstants.countryIcon[country]!,
                      text: country,
                      color: _country == country
                          ? theme.primaryContainer
                          : theme.secondaryContainer,
                      onTap: () {
                        context
                            .read<MealsPageNotifier>()
                            .changeCountry(country);
                        context.read<MealsPageNotifier>().fetchMeals();
                      },
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "$_country Meals",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 15,
            ),
            enabled == true
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: SizedBox(
                      height: 230,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return const Card(
                            elevation: 0,
                            child: SizedBox(
                              width: 160,
                              height: 170,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : SizedBox(
                    height: size.height * .3,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return MealsListItem(
                          size: size,
                          onTap: () {
                            Navigator.of(context).push(MealDetailPage.route(
                                id: item.idMeal!,
                                fetchMethod: FetchMethod.global));
                          },
                          item: item,
                          enabled: enabled,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class MealsListItem extends StatelessWidget {
  const MealsListItem({
    super.key,
    required this.item,
    required this.enabled,
    this.onTap,
    required this.size,
  });
  final bool enabled;
  final Meals item;
  final void Function()? onTap;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
          // color: Colors.white,
          elevation: 0,
          // color: Colors.red,
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: SizedBox(
                  height: size.height * .15,
                  width: size.width * .3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ItemPhoto(
                        item: item,
                        size: size,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                          child: Text(
                        "${item.strMeal}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ))
                    ],
                  )))),
    );
  }
}

class _ItemPhoto extends StatelessWidget {
  const _ItemPhoto({super.key, required this.item, required this.size});

  final Meals item;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: SizedBox(
        height: size.height * .2,
        child: Hero(
          tag: item.idMeal!,
          child: CachedNetworkImage(
            height: size.height * .1,
            width: size.width * .26,
            imageUrl: item.strMealThumb!,
            fit: BoxFit.cover,
            errorWidget: (ctx, url, err) => const Icon(Icons.error),
            placeholder: (ctx, url) => const Icon(Icons.image),
          ),
        ),
      ),
    );
  }
}
