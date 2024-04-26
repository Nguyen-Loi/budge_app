import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
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
          fontWeight: FontWeightManager.semiBold,
        ),
        gapH8,
        InternationalPhoneNumberInput(
          validator: validator,
          isEnabled: !disable,
          onInputChanged: onInputChanged,
          initialValue: initialValue,
          hintText: 'noData'.hardcoded,
          countries: const ['VN', 'SG', 'JP'],
        ),
      ],
    );
  }
}
