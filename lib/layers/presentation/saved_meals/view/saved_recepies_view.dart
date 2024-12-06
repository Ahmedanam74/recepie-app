import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recepies_app/layers/core/constants/app_functions.dart';
import 'package:recepies_app/layers/domain/usecase/get_saved_meals_usecase.dart';
import 'package:recepies_app/layers/domain/usecase/remove_saved_recepie_usecase.dart';
import 'package:recepies_app/layers/injector.dart';
import 'package:recepies_app/layers/presentation/details_page/controller/meal_detail_controller.dart';
import 'package:recepies_app/layers/presentation/details_page/view/meal_detail_view.dart';
import 'package:recepies_app/layers/presentation/saved_meals/controller/saved_recepies_notifier.dart';

class SavedRecepiesPage extends StatelessWidget {
  const SavedRecepiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final useCase = getIt<GetSavedMeals>();
    final removeUseCase = getIt<RemoveRecepie>();
    return ChangeNotifierProvider(
      create: (_) => SavedRecepiesNotifier(
          getSavedMeals: useCase, removeRecepie: removeUseCase),
      child: const SavedRecepiesView(),
    );
  }
}

class SavedRecepiesView extends StatefulWidget {
  const SavedRecepiesView({Key? key}) : super(key: key);

  @override
  State<SavedRecepiesView> createState() => _SavedRecepiesViewState();
}

class _SavedRecepiesViewState extends State<SavedRecepiesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedRecepiesNotifier>().getSavedRecepies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (SavedRecepiesNotifier cn) => cn.status,
    );

    if (status == SavedRecepiesStatus.initial ||
        status == SavedRecepiesStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (status == SavedRecepiesStatus.empty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          _CustomizedAppBar(),
          Expanded(
            child: Center(
              child: Text("No saved recepies"),
            ),
          )
        ],
      );
    } else {
      return const _Content();
    }
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final meals = context.select(
      (SavedRecepiesNotifier cn) => cn.mealDetails,
    );
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          const _CustomizedAppBar(),
          ...meals.map((list) {
            return Consumer<SavedRecepiesNotifier>(
              builder: (context, value, child) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  key: Key(list.idMeal!),
                  onDismissed: (direction) {
                    context
                        .read<SavedRecepiesNotifier>()
                        .removeSavedRecepie(list.idMeal!);
                    AppFunctions.showSnackbar(
                        context: context,
                        text: "Item deleted",
                        color: Colors.red);
                  },
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                              context,
                              MealDetailPage.route(
                                  id: list.idMeal!,
                                  fetchMethod: FetchMethod.local));
                          if (!context.mounted) return;
                          if (result == "Yep") {
                            context
                                .read<SavedRecepiesNotifier>()
                                .getSavedRecepies();
                          } else {
                          }
                        },
                        child: Card(
                          elevation: 0,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: SizedBox(
                              height: size.height * .13,
                              width: size.width * .9,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    child: SizedBox(
                                      height: size.height * .2,
                                      child: Hero(
                                        tag: list.idMeal!,
                                        child: CachedNetworkImage(
                                          height: size.height * .1,
                                          width: size.width * .25,
                                          imageUrl: list.strMealThumb!,
                                          fit: BoxFit.cover,
                                          errorWidget: (ctx, url, err) =>
                                              const Icon(Icons.error),
                                          placeholder: (ctx, url) =>
                                              const Icon(Icons.image),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        list.strMeal!,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        list.strCategory!,
                                        style: const TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          })
        ],
      ),
    );
  }
}

class _CustomizedAppBar extends StatelessWidget {
  const _CustomizedAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(18.0),
      child: Text(
        "Saved",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
      ),
    );
  }
}
