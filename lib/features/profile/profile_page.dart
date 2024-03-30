import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_avatar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/features/profile/profile_detail/profile_detail_view.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          BText.h2('Profile', color: ColorManager.white),
          gapH24,
          ListTile(
            title: BText.b1('Tester 1', color: ColorManager.white),
            leading: const BAvatar.network(
                'https://acpro.edu.vn/hinh-nhung-chu-meo-de-thuong/imager_173.jpg',
                size: 20),
            subtitle:
                BText.caption('Tester1@gmail.com', color: ColorManager.white),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: ColumnWithSpacing(
        children: [
          _item(
              icon: IconConstants.account,
              text: 'My Account',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileDetailView(),
                  ),
                );
              }),
          _item(
              icon: IconConstants.setting, text: 'Settings', onPressed: () {}),
          _item(icon: IconConstants.contact, text: 'Contact', onPressed: () {}),
          Expanded(child: _content())
        ],
      ),
    );
  }

  Widget _content() {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: BText.caption(
            'You joined BudgetApp on November 2023. It\'s been 1 month since then'
            'and our mission is still the same and help you better manage your money',
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
