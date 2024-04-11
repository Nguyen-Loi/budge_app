import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/view/goals_view/goals_view.dart';
import 'package:budget_app/view/history_view/history_page.dart';
import 'package:budget_app/view/home_page/home_page.dart';
import 'package:budget_app/view/new_budget_view/new_budget_view.dart';
import 'package:budget_app/view/profile_view/profile_page.dart';
import 'package:flutter/material.dart';

class MainPageBottomBar extends StatefulWidget {
  const MainPageBottomBar({Key? key}) : super(key: key);

  @override
  State<MainPageBottomBar> createState() => _MainPageBottomBarState();
}

final _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(IconConstants.home),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(IconConstants.history),
    label: 'History',
  ),
  BottomNavigationBarItem(
    icon: Icon(IconConstants.goals),
    label: 'Goals',
  ),
  BottomNavigationBarItem(
    icon: Icon(IconConstants.profile),
    label: 'Profile',
  )
];

class _MainPageBottomBarState extends State<MainPageBottomBar> {
  late int _selectedIndex;
  late List<Widget> _screens;
  @override
  void initState() {
    _selectedIndex = 0;
    _screens = [
      HomePage(),
      const HistoryPage(),
      GoalsView(),
      ProfilePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;

    return Scaffold(
      bottomNavigationBar: isSmallScreen
          ? BottomNavigationBar(
              unselectedItemColor: ColorManager.black,
              items: _navBarItems,
              currentIndex: _selectedIndex,
              selectedItemColor: ColorManager.purple11,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
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
                });
              },
              extended: isLargeScreen,
              destinations: _navBarItems
                  .map((item) => NavigationRailDestination(
                      icon: item.icon,
                      selectedIcon: item.activeIcon,
                      label: Text(
                        item.label!,
                      )))
                  .toList(),
            ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: _screens[_selectedIndex],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const NewBudgetView(),
          ));
        },
        child: Icon(IconConstants.add, color: ColorManager.white),
      ),
    );
  }
}
