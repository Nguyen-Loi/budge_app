import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_amount.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class UpdateWalletView extends ConsumerStatefulWidget {
  const UpdateWalletView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateWalletViewState();
}

class _UpdateWalletViewState extends ConsumerState<UpdateWalletView> {
  final _formKey = GlobalKey<FormState>();
  late int _newBalance;

  void _save(UserModel user) async {
    if (_formKey.currentState!.validate()) {
      ref
          .read(userBaseControllerProvider.notifier)
          .updateWallet(context, newValue: _newBalance);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userBaseControllerProvider)!;
    return BaseView(
        actions: [
          TextButton(
              onPressed: () {
                _save(user);
              },
              child: BText(context.loc.save.toUpperCase()))
        ],
        title: context.loc.updateBalance,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Card(
            elevation: 5,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: _form(context: context, user: user)),
          ),
        ));
  }

  Widget _form({required BuildContext context, required UserModel user}) {
    return Form(
        key: _formKey,
        child: ColumnWithSpacing(
          mainAxisSize: MainAxisSize.min,
          children: [
            _walletField(context: context, balance: user.balance),
          ],
        ));
  }

  Widget _walletField({required BuildContext context, required int balance}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SvgPicture.asset(SvgAssets.wallet, width: 32, height: 32),
            gapW8,
            BText.b1(context.loc.cash),
          ],
        ),
        gapH16,
        BFormFieldAmount(
          initialValue: balance,
          label: context.loc.balanceAdjustment,
          validator: (s) => s.validateWallet(context, newValue: balance),
          onChanged: (v) {
            if (v != null) {
              _newBalance = v;
            }
          },
        ),
      ],
    );
  }
}
