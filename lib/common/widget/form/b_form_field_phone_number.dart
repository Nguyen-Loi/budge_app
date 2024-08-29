import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class BFormFieldPhoneNumber extends StatelessWidget {
  const BFormFieldPhoneNumber(
      {super.key,
      this.label = 'Phone number',
      this.disable = false,
      required this.onInputChanged,
      this.validator,
      this.initialValue});
  final String label;
  final void Function(PhoneNumber)? onInputChanged;
  final PhoneNumber? initialValue;
  final bool disable;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
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
          isEnabled: !disable,
          onInputChanged: onInputChanged,
          initialValue: initialValue,
          hintText: 'x-xxx-xxx',
          countries: const ['VN', 'SG', 'JP'],
          inputDecoration: InputDecoration(
            filled: Theme.of(context).inputDecorationTheme.filled,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
            helperStyle: Theme.of(context).inputDecorationTheme.helperStyle,
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
            focusedErrorBorder:
                Theme.of(context).inputDecorationTheme.focusedErrorBorder,
            errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
            focusColor: Theme.of(context).inputDecorationTheme.focusColor,
            iconColor: Theme.of(context).inputDecorationTheme.iconColor,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            disabledBorder:
                Theme.of(context).inputDecorationTheme.disabledBorder,
          ),
        ),
      ],
    );
  }
}
