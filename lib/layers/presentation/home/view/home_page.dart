import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:recepies_app/layers/core/constants/svg_pictures.dart';
import 'package:recepies_app/layers/presentation/home/changeNotifier/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageNotifier(),
      child: HomeView(),
    );
  }
}

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final page = context.select((HomePageNotifier c) => c.page);
    final pages = context.select((HomePageNotifier c) => c.pages);
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: page,
          items: <Widget>[
            SvgPicture.asset(
              AppSvg.home,
              colorFilter: ColorFilter.mode(
                  page == 0 ? theme.onPrimaryContainer : theme.onPrimary,
                  BlendMode.srcIn),
            ),
            SvgPicture.asset(
              AppSvg.search,
              colorFilter: ColorFilter.mode(
                  page == 1 ? theme.onPrimaryContainer : theme.onPrimary,
                  BlendMode.srcIn),
            ),
            SvgPicture.asset(
              AppSvg.saveDouble,
              colorFilter: ColorFilter.mode(
                  page == 2 ? theme.onPrimaryContainer : theme.onPrimary,
                  BlendMode.srcIn),
            ),
          ],
          color: theme.primary,
          buttonBackgroundColor: theme.primaryContainer,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            context.read<HomePageNotifier>().changePage(index);
          },
          letIndexChange: (index) => true,
        ),
        body: pages[page]);
  }
}
