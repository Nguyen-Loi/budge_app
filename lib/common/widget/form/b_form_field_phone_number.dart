import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class BFormFieldPhoneNumber extends StatelessWidget {
  const BFormFieldPhoneNumber(
      {super.key,
      this.label = 'Phone number',
      required this.onInputChanged,
      this.initialValue});
  final String label;
  final void Function(PhoneNumber)? onInputChanged;
  final PhoneNumber? initialValue;

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
          onInputChanged: (_) {},
          initialValue: initialValue,
        ),
      ],
    );
  }
}
