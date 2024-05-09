import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_divider.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class HomeUpdateWalletCard extends ConsumerWidget {
  const HomeUpdateWalletCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(userBaseControllerProvider)!.balance;
    return _item(
        value: balance,
        onPressed: () {
          Navigator.pushNamed(context, RoutePath.updateWallet);
        });
  }

  Widget _item({required int value, required void Function()? onPressed}) {
    Color color = ColorManager.white;
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: ColorManager.purple15,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BText.b1(
                    'Ví của tôi',
                    color: color,
                  ),
                  Icon(IconManager.arrowNext, color: color)
                ],
              ),
              BDivider.h(
                color: color,
                thickness: 0.4,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    SvgAssets.wallet,
                    width: 32,
                    height: 32,
                  ),
                  gapW8,
                  BText('Tiền mặt', color: ColorManager.white),
                  gapW8,
                  Expanded(
                      child: BText(
                    value.toMoneyStr(),
                    color: color,
                    textAlign: TextAlign.right,
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
