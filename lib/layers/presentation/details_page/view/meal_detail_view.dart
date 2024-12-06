import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:recepies_app/layers/core/constants/app_functions.dart';
import 'package:recepies_app/layers/core/constants/svg_pictures.dart';
import 'package:recepies_app/layers/domain/usecase/added_check_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/get_meal_details_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/get_saved_recepies_by_id_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/remove_saved_recepie_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/save_recepie_usecase.dart';
import 'package:recepies_app/layers/injector.dart';
import 'package:recepies_app/layers/presentation/details_page/controller/meal_detail_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

// -----------------------------------------------------------------------------
// Page
// -----------------------------------------------------------------------------
class MealDetailPage extends StatelessWidget {
  const MealDetailPage({super.key});

  static Route<String> route(
      {required String id, required FetchMethod fetchMethod}) {
    final useCase = getIt<GetMealDetails>();
    final saveUseCase = getIt<SaveRecepie>();
    final addCheckUseeCase = getIt<AddCheck>();
    final getSaveUseeCase = getIt<GetSavedMealsById>();
    final removeSavedUseeCase = getIt<RemoveRecepie>();
    return MaterialPageRoute(
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => MealDetailNotifier(
              id: id,
              getMealDetails: useCase,
              saveRecepies: saveUseCase,
              addCheck: addCheckUseeCase,
              getSavedMealsById: getSaveUseeCase,
              removeRecepie: removeSavedUseeCase,
              fetchMethod: fetchMethod),
          child: const MealDetailPage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => const MealsDetailView();
}

// -----------------------------------------------------------------------------
// View
// -----------------------------------------------------------------------------
class MealsDetailView extends StatefulWidget {
  const MealsDetailView({super.key});

  @override
  State<MealsDetailView> createState() => _MealsDetailViewState();
}

class _MealsDetailViewState extends State<MealsDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealDetailNotifier>().fetchRecepiesDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (MealDetailNotifier cn) => cn.status,
    );
    return Scaffold(
        body: status == DetailPageStatus.initial ||
                status == DetailPageStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : _Content());
  }
}

// -----------------------------------------------------------------------------
// Content
// -----------------------------------------------------------------------------
// ignore: must_be_immutable
class _Content extends StatelessWidget {
  _Content({super.key});
  String popResult = "Nope";
  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final textTheme = theme.textTheme;
    // final colorScheme = theme.colorScheme;
    final theme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    final meals = context.select(
      (MealDetailNotifier cn) => cn.mealDetails[0],
    );
    final result = context.select(
      (MealDetailNotifier cn) => cn.result,
    );

    return Skeletonizer(
      enabled: false,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Hero(
                  tag: meals.idMeal!,
                  child: CachedNetworkImage(
                    imageUrl: meals.strMealThumb!,
                    fit: BoxFit.cover,
                    height: size.height * .4,
                    width: size.width,
                  ),
                ),
              ),
              Positioned(
                top: size.height * .1,
                left: size.width * .01,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.secondaryContainer,
                        maxRadius: 20,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context, popResult);
                              // print("$popResult======");
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: theme.onSecondaryContainer,
                              size: 20,
                            )),
                      ),
                      result == -1
                          ? CircleAvatar(
                              backgroundColor: theme.secondaryContainer,
                              maxRadius: 20,
                              child: IconButton(
                                  onPressed: () {
                                    context
                                        .read<MealDetailNotifier>()
                                        .saveRecepie();
                                    AppFunctions.showSnackbar(
                                        context: context,
                                        text: "Added to saved",
                                        color: Colors.green);
                                    popResult = "Nope";
                                  },
                                  icon: SvgPicture.asset(
                                    AppSvg.save,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.black, BlendMode.srcIn),
                                  )),
                            )
                          : CircleAvatar(
                              backgroundColor: theme.secondaryContainer,
                              maxRadius: 20,
                              child: IconButton(
                                onPressed: () {
                                  context
                                      .read<MealDetailNotifier>()
                                      .removeSavedRecepie(meals.idMeal!);
                                  AppFunctions.showSnackbar(
                                      context: context,
                                      text: "Removed from saved",
                                      color: Colors.red);
                                  popResult = "Yep";
                                },
                                // icon: SvgPicture.asset(
                                //   AppSvg.save,
                                //   colorFilter: ColorFilter.mode(
                                //       Colors.black, BlendMode.darken),
                                // )
                                icon: SvgPicture.asset(
                                  AppSvg.saved,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.black, BlendMode.srcIn),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: size.height * .34,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: theme.secondaryContainer,
                      borderRadius: BorderRadius.circular(40)),
                  width: size.width,
                  height: size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 80,
                            height: 8,
                            decoration: BoxDecoration(
                                color: const Color(0xFFf1f1f1),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          meals.strMeal!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Category: ${meals.strCategory!}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: size.width * .9,
                          height: size.height * .4,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: theme.primaryContainer,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2, //, Shadow color,
                                  offset: const Offset(0, 2)),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Instructions",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: theme.onPrimaryContainer),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  meals.strInstructions!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: theme.onPrimaryContainer),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.all(18),
                          width: size.width * .9,
                          height: size.height * .4,
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 5, right: 5),
                          decoration: BoxDecoration(
                            color: theme.primaryContainer,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2, //, Shadow color,
                                  offset: const Offset(0, 2),
                                  blurStyle: BlurStyle.solid),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Ingredients",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: List.generate(
                                      meals.ingredients!.length, (index) {
                                    return CustomizedRow(
                                        ingrediant: meals.ingredients![index],
                                        measures: meals.measures![index]);
                                  }),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height * .9,
                left: size.width * .23,
                child: ElevatedButton.icon(
                  label: Text("Watch Videos",
                      style: TextStyle(
                          fontSize: 20,
                          color: theme.onPrimary,
                          fontWeight: FontWeight.w400)),
                  icon: SvgPicture.asset(
                    AppSvg.playButton,
                    width: 25,
                    // height: 50,
                    colorFilter:
                        ColorFilter.mode(theme.onPrimary, BlendMode.srcIn),
                  ),
                  onPressed: () {
                    launchUrl(Uri.parse(meals.strYoutube!));
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(210, 55),
                      backgroundColor: theme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "error";
    }
  }
}

class CustomizedRow extends StatelessWidget {
  const CustomizedRow({
    super.key,
    required this.ingrediant,
    required this.measures,
  });

  final String ingrediant;
  final String measures;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ingrediant,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        Text(
          measures,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Episode
// -----------------------------------------------------------------------------
class EpisodeItem extends StatelessWidget {
  const EpisodeItem({super.key, required this.ep});

  final String ep;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final name = ep.split('/').last;

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: colorScheme.surfaceVariant,
        ),
        height: 80,
        width: 80,
        child: Center(
          child: Text(
            name,
            style: textTheme.bodyLarge!.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
