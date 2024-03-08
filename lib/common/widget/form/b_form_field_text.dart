import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';

class BFormFieldText extends StatelessWidget {
  final int? maxLines;
  final int? maxLength;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String? initialValue;
  final TextInputType? textInputType;

  const BFormFieldText(this.controller,
      {super.key,
      this.maxLines,
      this.maxLength,
      required this.label,
      this.hint = 'Enter your text',
      this.validator,
      this.initialValue,
      this.textInputType});

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
          maxLength: maxLength,
          maxLines: maxLines,
          controller: controller,
          validator: validator,
          keyboardType: textInputType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
