import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_avatar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:budget_app/view/profile_view/controller/profile_controller.dart';
import 'package:budget_app/view/profile_view/profile_detail/profile_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
    return ColoredBox(
      color: ColorManager.purple12,
      child: Column(
        children: [
          gapH40,
          _buildTop(),
          gapH24,
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: _body(context)),
          )
        ],
      ),
    );
  }

  Widget _buildTop() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          BText.h2('profile'.hardcoded, color: ColorManager.white),
          gapH24,
          _info(),
        ],
      ),
    );
  }

  Widget _info() {
    return Consumer(builder: (_, ref, __) {
      final user = ref.watch(userControllerProvider)!;
      return ListTile(
        title: BText.b1(user.name, color: ColorManager.white),
        leading: BAvatar.network(user.profileUrl, size: 20),
        subtitle: BText.caption(user.email, color: ColorManager.white),
      );
    });
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: ColumnWithSpacing(
        children: [
          _item(
              icon: IconConstants.account,
              text: 'My Account'.hardcoded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileDetailView(),
                  ),
                );
              }),
          _item(
              icon: IconConstants.setting,
              text: 'settings'.hardcoded,
              onPressed: () {
                Navigator.pushNamed(context, RoutePath.settings);
              }),
          _item(icon: IconConstants.contact, text: 'contact'.hardcoded, onPressed: () {}),
          _item(
              icon: IconConstants.signOut,
              text: 'signOut'.hardcoded,
              onPressed: () {
                ref.read(profileController.notifier).signOut(context);
              }),
          Expanded(child: _content())
        ],
      ),
    );
  }

  Widget _content() {
    return  Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: BText.caption(
            'November 2023'
            'userJoinDescriptions'.hardcoded,
            textAlign: TextAlign.center),
      ),
    );
  }

  Widget _item(
      {required IconData icon,
      required String text,
      required Function() onPressed}) {
    return ListTile(
      title: BText(text, fontWeight: FontWeightManager.semiBold),
      onTap: onPressed,
      trailing: Icon(
        IconConstants.arrowNext,
        size: 15,
        color: ColorManager.black,
      ),
      leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: ColorManager.purple25,
          ),
          child: Icon(icon, color: ColorManager.purple11)),
    );
  }
}
