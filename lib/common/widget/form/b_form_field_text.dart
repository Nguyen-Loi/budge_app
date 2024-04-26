import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

enum _TypeField { controller, init }

class BFormFieldText extends StatelessWidget {
  final int? maxLines;
  final int? maxLength;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? initialValue;
  final bool disable;
  final TextInputType? textInputType;
  final void Function(String)? onChanged;
  final _TypeField _typeField;

  const BFormFieldText(
    this.controller, {
    super.key,
    this.maxLines,
    this.maxLength,
    this.disable = false,
    required this.label,
    this.hint,
    this.validator,
    this.textInputType,
  })  : _typeField = _TypeField.controller,
        onChanged = null,
        initialValue = null;

  const BFormFieldText.init(
      {super.key,
      this.maxLines,
      this.maxLength,
      this.initialValue,
      this.disable = false,
      required this.label,
      this.hint,
      this.validator,
      this.textInputType,
      this.onChanged})
      : _typeField = _TypeField.init,
        controller = null;

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
        _field(),
      ],
    );
  }

  Widget _field() {
    switch (_typeField) {
      case _TypeField.controller:
        return _controller();
      case _TypeField.init:
        return _init();
    }
  }

  Widget _controller() {
    return TextFormField(
      readOnly: disable,
      maxLength: maxLength,
      maxLines: maxLines,
      controller: controller,
      validator: validator,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hint??'textFieldHintDefault'.hardcoded,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _init() {
    return TextFormField(
      readOnly: disable,
      initialValue: initialValue,
      maxLength: maxLength,
      maxLines: maxLines,
      validator: validator,
      keyboardType: textInputType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint??'textFieldHintDefault'.hardcoded,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
