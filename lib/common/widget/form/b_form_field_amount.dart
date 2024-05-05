import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BFormFieldAmount extends StatelessWidget {
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String? initialValue;

  BFormFieldAmount(
    this.controller, {
    super.key,
    required this.label,
    this.hint,
    this.validator,
    this.initialValue,
  });

  String _formatNumber(String s) {
    try {
      return NumberFormat.decimalPattern('en').format(int.parse(s));
    } catch (e) {
      return s;
    }
  }

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(
          label,
          fontWeight: FontWeightManager.semiBold,
        ),
        gapH8,
        Consumer(builder: (context, ref, _) {
          String userCurrency = ref.watch(userControllerProvider
              .select((value) => value!.currencyType.code));
          String currency =
              NumberFormat.compactSimpleCurrency(locale: userCurrency)
                  .currencySymbol;
          return TextFormField(
            initialValue: initialValue,
            textInputAction: TextInputAction.done,
            controller: _controller,
            validator: validator,
            maxLength: 16,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: currency,
              hintText: hint ?? context.loc.amountHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onChanged: (string) {
              string = _formatNumber(string.replaceAll(',', ''));
              _controller.value = TextEditingValue(
                text: string,
                selection: TextSelection.collapsed(offset: string.length),
              );
            },
          );
        }),
      ],
    );
  }
}
