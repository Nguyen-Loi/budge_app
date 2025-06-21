import 'package:budget_app/common/widget/b_avatar_profile.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/pakage_info_base_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({
    super.key,
    required this.drawerAnimation,
  });
  final Animation<double> drawerAnimation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: AnimatedBuilder(
        animation: drawerAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.secondary.withAlpha(100),
                  Theme.of(context).colorScheme.secondary.withAlpha(30),
                ],
              ),
            ),
            child: Column(
              children: [
                _buildDrawerHeader(context),
                Expanded(child: _buildDrawerBody(context, ref)),
                _buildDrawerFooter(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      final user = ref.watch(userBaseControllerProvider);
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withAlpha(200),
            ],
          ),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(drawerAnimation),
          child: Row(
            children: [
              BAvatarProfile(
                url: user.profileUrl,
                username: user.name,
                size: 25,
              ),
              gapW16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BText.b1(
                      user.name,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    gapH4,
                    BText.caption(
                      user.email,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withAlpha(180),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDrawerBody(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (_, ref, __) {
      final isLogin = ref.watch(userBaseControllerProvider.notifier).isLogin;

      final menuItems = [
        if (isLogin)
          _DrawerMenuItem(
            icon: IconManager.account,
            title: context.loc.myAccount,
            onTap: () => _navigateToProfile(isLogin: isLogin, context: context),
          ),
        _DrawerMenuItem(
          icon: IconManager.botChat,
          title: context.loc.chatWithViBot,
          onTap: () => _navigateToChat(
            isLogin: isLogin,
            context: context,
          ),
        ),
        _DrawerMenuItem(
          icon: IconManager.setting,
          title: context.loc.settings,
          onTap: () => _navigateToSettings(context),
        ),
        _DrawerMenuItem(
          icon: IconManager.contact,
          title: context.loc.contact,
          onTap: () => _showContactDialog(context),
        ),
        if (isLogin)
          _DrawerMenuItem(
            icon: IconManager.signOut,
            title: context.loc.signOut,
            onTap: () => _signOut(
              context: context,
              ref: ref,
            ),
            isDestructive: true,
          ),
        if (!isLogin)
          _DrawerMenuItem(
            icon: IconManager.signIn,
            title: context.loc.signIn,
            onTap: () => _navigateToLogin(context),
          ),
      ];

      return ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: drawerAnimation,
              curve: Interval(
                0.1 + (index * 0.1),
                0.5 + (index * 0.1),
                curve: Curves.easeOut,
              ),
            )),
            child: FadeTransition(
              opacity: drawerAnimation,
              child: _buildDrawerItem(context, menuItems[index], index),
            ),
          );
        },
      );
    });
  }

  Widget _buildDrawerItem(
      BuildContext context, _DrawerMenuItem item, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
            item.onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: item.isDestructive
                        ? Theme.of(context).colorScheme.error.withAlpha(20)
                        : Theme.of(context).colorScheme.primary.withAlpha(20),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.isDestructive
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                gapW16,
                Expanded(
                  child: BText(
                    item.title,
                    fontWeight: FontWeight.w600,
                    color: item.isDestructive
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(drawerAnimation),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Consumer(builder: (_, ref, __) {
          final appVersion =
              ref.watch(packageInfoBaseControllerProvider).version;

          return Column(
            children: [
              BText.caption(
                context.loc.pAppVersion(appVersion),
                textAlign: TextAlign.center,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Navigation methods
  void _navigateToProfile(
      {required BuildContext context, required bool isLogin}) {
    if (_validateLogin(context, isLogin: isLogin)) {
      Navigator.pushNamed(context, RoutePath.profile);
    }
  }

  void _navigateToChat({required bool isLogin, required BuildContext context}) {
    if (_validateLogin(context, isLogin: isLogin)) {
      Navigator.pushNamed(context, RoutePath.chat);
    }
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.pushNamed(context, RoutePath.settings);
  }

  void _showContactDialog(BuildContext context) {
    BDialogInfo(
      message: context.loc.developingFreatures,
      dialogInfoType: BDialogInfoType.warning,
    ).present(context);
  }

  void _signOut({required BuildContext context, required WidgetRef ref}) async {
    await ref.read(homeControllerProvider.notifier).signOut(context);
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, RoutePath.login);
  }

  bool _validateLogin(BuildContext context, {required bool isLogin}) {
    if (!isLogin) {
      BDialogInfo(
              message: context.loc.loginToUse,
              dialogInfoType: BDialogInfoType.warning)
          .present(context);
      return false;
    }
    return true;
  }
}

class _DrawerMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}
