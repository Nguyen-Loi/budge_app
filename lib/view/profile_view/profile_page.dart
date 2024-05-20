import 'package:budget_app/common/widget/b_avatar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/profile_view/controller/profile_controller.dart';
import 'package:budget_app/view/profile_view/profile_detail/profile_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseView(
        title: context.loc.profile,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _info()),
            gapH24,
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
                  child: _body(context)),
            )
          ],
        ));
  }

  Widget _info() {
    return Consumer(builder: (_, ref, __) {
      final user = ref.watch(userBaseControllerProvider);
      return user == null
          ? const SizedBox.shrink()
          : ListTile(
              title: BText.b1(user.name),
              leading: BAvatar.network(user.profileUrl, size: 20),
              subtitle: BText.caption(user.email),
            );
    });
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: ColumnWithSpacing(
        children: [
          _item(
              icon: IconManager.account,
              text: context.loc.myAccount,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileDetailView(),
                  ),
                );
              }),
          _item(
              icon: IconManager.setting,
              text: context.loc.settings,
              onPressed: () {
                Navigator.pushNamed(context, RoutePath.settings);
              }),
          _item(
              icon: IconManager.contact,
              text: context.loc.contact,
              onPressed: () {}),
          _item(
              icon: IconManager.signOut,
              text: context.loc.signOut,
              onPressed: () {
                ref.read(profileController.notifier).signOut(context);
              }),
          Expanded(child: _content())
        ],
      ),
    );
  }

  Widget _content() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: BText.caption(
            context.loc.pUserJoinDescriptions('Novemer2023', '4'),
            textAlign: TextAlign.center),
      ),
    );
  }

  Widget _item(
      {required IconData icon,
      required String text,
      required Function() onPressed}) {
    return ListTile(
      title: BText(text, fontWeight: FontWeight.w700),
      onTap: onPressed,
      trailing: Icon(
        IconManager.arrowNext,
        size: 15,
      ),
      leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primaryContainer,
          )),
    );
  }
}
