import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class BFormFieldAmount extends StatelessWidget {
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String? initialValue;

  const BFormFieldAmount(
    this.controller, {
    super.key,
    required this.label,
    this.hint,
    this.validator,
    this.initialValue,
  });

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
        TextFormField(
          initialValue: initialValue,
          textInputAction: TextInputAction.done,
          controller: controller,
          validator: validator,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint??'textFieldHintDefault'.hardcoded,
            suffixText: '.000 đ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
