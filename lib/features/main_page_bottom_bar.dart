import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/features/home/home_page.dart';
import 'package:budget_app/features/limit/limit_page.dart';
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
    icon: Icon(IconConstants.limit),
    label: 'Limit',
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
      LimitPage(),
      const SizedBox(),
      const SizedBox(),
      const SizedBox()
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
              // fixedColor: ColorManager.purple11,

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
    );
  }
}
