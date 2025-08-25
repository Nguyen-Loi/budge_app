import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/size_constants.dart';
import 'package:budget_app/core/extension/extension_exception.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/core/src/b_notification.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/budget_view/budget_page.dart';
import 'package:budget_app/view/onboaring_view/onboarding_screen.dart';
import 'package:budget_app/view/main_page_view/controller/main_page_controller.dart';
import 'package:budget_app/view/report_page/report_page.dart';
import 'package:budget_app/view/transactions_view/transaction_view.dart';
import 'package:budget_app/view/home_page/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MainPageView extends ConsumerStatefulWidget {
  const MainPageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainPageBottomBarState();
}

List<BottomNavigationBarItem> _navBarItems(BuildContext context) {
  return [
    BottomNavigationBarItem(
      icon: Icon(IconManager.homeBar),
      label: context.loc.home,
    ),
    BottomNavigationBarItem(
      icon: Icon(IconManager.transactionBar),
      label: context.loc.transactions,
    ),
    BottomNavigationBarItem(
      icon: Icon(IconManager.budgetBar),
      label: context.loc.budget,
    ),
    BottomNavigationBarItem(
      icon: Icon(IconManager.reportBar),
      label: context.loc.report,
    ),
  ];
}

class _MainPageBottomBarState extends ConsumerState<MainPageView> {
  late int _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    _selectedIndex = 0;
    _pageController = PageController(initialPage: _selectedIndex);
    _listenNotification();
    super.initState();
  }

  void _navigateToPage(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<Widget> get _screens => [
        HomePage(
          onNavigateToTransactions: () => _navigateToPage(1),
          onNavigateToBudgets: () => _navigateToPage(2),
        ),
        const TransactionView(),
        const BudgetPage(),
        const ReportPage(),
      ];

  void _listenNotification() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((e) => logInfo(e?.toMap().toString() ?? 'NoData'));

    FirebaseMessaging.onMessage.listen((message) {
      logSuccess(
          '🔔 [FOREGROUND] Notification Received: ${message.toMap().toString()}');
      ref.read(notificationProvider).showFlutterNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logInfo(message.data.toString());
    });
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: ref.watch(mainPageFutureProvider(context)).when(
              data: (_) => _buildWithFirstTimeCheck(),
              error: (e, __) {
                return Scaffold(
                    body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: BStatus.error(
                      text: e.toErrorMessage(context.loc),
                    )),
                    SizedBox(height: 16),
                    BButton(
                      onPressed: () {
                        final refresh = ref.refresh(mainPageControllerProvider);
                        logInfo('Refresh status: $refresh');
                      },
                      title: context.loc.refresh,
                    )
                  ],
                ));
              },
              loading: () => _loadingWidget(),
            ));
  }

  Widget _buildWithFirstTimeCheck() {
    final sharedUtility = ref.read(sharedUtilityProvider);
    bool isFirstTimeInfo = sharedUtility.isDataFirstTime();
    if (isFirstTimeInfo) {
      _checkAndShowFirstTimeSetup();
      sharedUtility.setDataFirstTimeIsFalse();
    }
    return body();
  }

  Future<bool> _checkAndShowFirstTimeSetup() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final result = await Navigator.of(context).pushNamed(
          RoutePath.onboarding,
        ) as OnboardingResult?;

        if (mounted) {
          final currentUser = ref.read(userBaseControllerProvider);
          final token = await ref.read(messagingProvider).getToken();
          final updatedUser = currentUser.copyWith(
              name: result?.userName,
              currencyTypeValue: result?.currency.code,
              token: token);
          await ref
              .read(userBaseControllerProvider.notifier)
              .updateUser(updatedUser);
        }
      }
    });
    return true;
  }

  Widget _loadingWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              SvgAssets.iconApp,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            BText.b1(
              context.loc.initializingTheApplication,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  Widget body() {
    final bool isSmallScreen = SizeConstants.isSmallScreen(context);
    final bool isMediumScreen = SizeConstants.isMediumScreen(context);
    return Scaffold(
      bottomNavigationBar: isSmallScreen
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: _navBarItems(context),
              unselectedItemColor: Theme.of(context).colorScheme.onSurface,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              currentIndex: _selectedIndex,
              onTap: _navigateToPage)
          : null,
      body: Row(
        children: <Widget>[
          if (!isSmallScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _navigateToPage,
              extended: !isMediumScreen,
              selectedLabelTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
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
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: _screens),
          )
        ],
      ),
    );
  }
}
