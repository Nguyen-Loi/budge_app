import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_amount.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class UpdateWalletView extends ConsumerWidget {
  UpdateWalletView({super.key});
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseView(
        actions: [
          TextButton(
              onPressed: () {}, child: BText(context.loc.save.toUpperCase()))
        ],
        title: 'Điều chỉnh số dư'.hardcoded,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ColoredBox(
            color: ColorManager.purple25,
            child: Padding(padding: const EdgeInsets.all(16), child: _wallet()),
          ),
        ));
  }

  Widget _wallet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SvgPicture.asset(SvgAssets.wallet, width: 32, height: 32),
            gapW8,
            const BText.b1('Tiền mặt'),
          ],
        ),
        gapH16,
        BFormFieldAmount(_amountController, label: 'Nhập số dư hiện tại'),
      ],
    );
  }
}
