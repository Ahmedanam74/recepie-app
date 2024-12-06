import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recepies_app/layers/domain/entity/meal_detail_entity.dart';
import 'package:recepies_app/layers/domain/usecase/get_meal_search_usecase.dart';
import 'package:recepies_app/layers/injector.dart';
import 'package:recepies_app/layers/presentation/details_page/controller/meal_detail_controller.dart';
import 'package:recepies_app/layers/presentation/details_page/view/meal_detail_view.dart';
import 'package:recepies_app/layers/presentation/search_page/change_notifier/search_page_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final useCase = getIt<GetMealSearch>();
    return ChangeNotifierProvider(
      create: (_) => SearchPageNotifier(getMealSearch: useCase),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: _SearchBar(),
          ),
          const Expanded(child: _SearchBody()),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final showTextField =
        context.select((SearchPageNotifier c) => c.showTextField);

    return AnimatedContainer(
      color: theme.secondaryContainer,
      margin: showTextField == false
          ? const EdgeInsets.all(10.0)
          : const EdgeInsets.all(0.0),
      duration: const Duration(milliseconds: 200),
      width: size.width * .95,
      height: showTextField == false ? size.height * .07 : size.height * .08,
      child: showTextField == false
          ? InkWell(
              onTap: () {
                context.read<SearchPageNotifier>().show();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Center(
                child: Text(
                  "Search",
                  style: TextStyle(
                    color: theme.onSecondaryContainer,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          : Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<SearchPageNotifier>().show();
                    _textController.clear();
                    context.read<SearchPageNotifier>().fetchMealDetails('');
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search query",
                    ),
                    onChanged: (text) {
                      // Notify the ChangeNotifier with the new search text
                      context.read<SearchPageNotifier>().fetchMealDetails(text);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _textController.clear();
                    context.read<SearchPageNotifier>().fetchMealDetails('');
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((SearchPageNotifier c) => c.status);

    switch (status) {
      case SearchPageStatus.empty:
        return const Center(child: Text('Please enter a term to begin'));
      case SearchPageStatus.loading:
        return const Center(child: CircularProgressIndicator.adaptive());
      case SearchPageStatus.failed:
        return const Center(child: Text('Something went wrong'));
      case SearchPageStatus.success:
        final mealDetails =
            context.select((SearchPageNotifier c) => c.mealDetails);
        return mealDetails.isEmpty
            ? const Center(child: Text('No Results'))
            : _SearchResults(items: mealDetails);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.items});

  final List<MealDetails> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...items.map(
              (toElement) => _SearchResultItem(onTap: () {}, item: toElement))
        ],
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem({required this.item, this.onTap});

  final MealDetails item;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MealDetailPage.route(
              id: item.idMeal!, fetchMethod: FetchMethod.global));
        },
        child: Card(
          child: ListTile(
            leading: Hero(
              tag: item.idMeal!,
              child: CachedNetworkImage(
                imageUrl: item.strMealThumb!,
                fit: BoxFit.cover,
                errorWidget: (ctx, url, err) => const Icon(Icons.error),
                placeholder: (ctx, url) => const Icon(
                  Icons.image,
                ),
              ),
            ),
            title: Text(item.strMeal!),
            subtitle: Text(item.strArea!),
          ),
        ));
  }
}
