import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/language_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class BFormFieldPhoneNumber extends ConsumerWidget {
  const BFormFieldPhoneNumber(
      {super.key,
      this.label = 'Phone number',
      this.disable = false,
      required this.onInputChanged,
      this.validator,
      PhoneNumber? initialValue})
      : _initialValue = initialValue;
  final String label;
  final void Function(PhoneNumber)? onInputChanged;
  final PhoneNumber? _initialValue;
  final bool disable;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LanguageEnum language = ref.watch(languageControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(
          label,
          fontWeight: FontWeight.w700,
        ),
        gapH8,
        InternationalPhoneNumberInput(
          validator: validator,
          ignoreBlank: false,
          isEnabled: !disable,
          onInputChanged: onInputChanged,
          initialValue: _initialValue ??
              PhoneNumber(
                  isoCode: language.isoCode, dialCode: language.dialCode),
          countries: const ['VN', 'SG', 'JP', 'US', 'CN', 'KR', 'TH'],
          inputDecoration: InputDecoration(
              filled: Theme.of(context).inputDecorationTheme.filled,
              fillColor: disable
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).inputDecorationTheme.fillColor,
              errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
              helperStyle: Theme.of(context).inputDecorationTheme.helperStyle,
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              focusedErrorBorder:
                  Theme.of(context).inputDecorationTheme.focusedErrorBorder,
              errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
              focusColor: Theme.of(context).inputDecorationTheme.focusColor,
              iconColor: Theme.of(context).inputDecorationTheme.iconColor,
              enabledBorder:
                  Theme.of(context).inputDecorationTheme.enabledBorder,
              disabledBorder:
                  Theme.of(context).inputDecorationTheme.disabledBorder,
              // label: Text('sss'),
              label: BText.caption("xxx-xxx-xxxx"),
              floatingLabelBehavior: FloatingLabelBehavior.never),
        ),
      ],
    );
  }
}
