import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/budget_view/budget_page.dart';
import 'package:budget_app/view/main_page_view/controller/main_page_controller.dart';
import 'package:budget_app/view/transactions_view/transaction_view.dart';
import 'package:budget_app/view/home_page/home_page.dart';
import 'package:budget_app/view/profile_view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPageView extends ConsumerStatefulWidget {
  const MainPageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainPageBottomBarState();
}

List<BottomNavigationBarItem> _navBarItems(BuildContext context) {
  return [
    BottomNavigationBarItem(
      icon: Icon(IconManager.home),
      label: context.loc.home,
    ),
    BottomNavigationBarItem(
      icon: Icon(IconManager.transaction),
      label: context.loc.transactions,
    ),
    BottomNavigationBarItem(
      icon: Icon(IconManager.budget),
      label: context.loc.budget,
    ),
    BottomNavigationBarItem(
      icon: Icon(IconManager.profile),
      label: context.loc.profile,
    )
  ];
}

class _MainPageBottomBarState extends ConsumerState<MainPageView> {
  late int _selectedIndex;
  late PageController _pageController;
  late List<Widget> _screens;
  @override
  void initState() {
    _selectedIndex = 0;
    _pageController = PageController(initialPage: _selectedIndex);
    _screens = [
      const HomePage(),
      const TransactionView(),
      const BudgetPage(),
      const ProfilePage(),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(mainPageFutureProvider).when(
          data: (_) => _body(),
          error: (_, __) => const Scaffold(body: BStatus.error()),
          loading: () => const Scaffold(body: Center(child: BStatus.loading())),
        );
  }

  Widget _body() {
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (ref.watch(budgetBaseControllerProvider).isEmpty) {
            BDialogInfo(
              message: context.loc.youMustCreateAtLeastOneBudget,
              dialogInfoType: BDialogInfoType.warning,
            ).presentAction(
              context,
              onSubmit: () {
                Navigator.pushNamed(context, RoutePath.newBudget);
              },
              textSubmit: context.loc.navigateToIt,
            );
          } else {
            Navigator.pushNamed(context, RoutePath.newTransaction);
          }
        },
        heroTag: RoutePath.newTransaction,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        child: Icon(
          Icons.add,
          color: ColorManager.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: isSmallScreen
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: _navBarItems(context),
              unselectedItemColor: Theme.of(context).colorScheme.onSurface,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                  _pageController.jumpToPage(_selectedIndex);
                });
              })
          : null,
      body: Row(
        children: <Widget>[
          if (!isSmallScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                  _pageController.jumpToPage(_selectedIndex);
                });
              },
              extended: isLargeScreen,
              destinations: _navBarItems(context)
                  .map((item) => NavigationRailDestination(
                      icon: item.icon,
                      selectedIcon: item.activeIcon,
                      label: Text(
                        item.label!,
                      )))
                  .toList(),
            ),
          if (!isSmallScreen) const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _screens),
          )
        ],
      ),
    );
  }
}
