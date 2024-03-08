import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:flutter/material.dart';

class BFormFieldPassword extends StatefulWidget {
  final int? maxLength;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String? initialValue;

  const BFormFieldPassword(
    this.controller, {
    super.key,
    this.maxLength,
    this.label,
    this.hint = 'Enter your password',
    this.validator,
    this.initialValue,
  });

  @override
  State<BFormFieldPassword> createState() => _BFormFieldPasswordState();
}

class _BFormFieldPasswordState extends State<BFormFieldPassword> {
  late bool _passwordVisible;
  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(
          widget.label ?? 'Password',
          fontWeight: FontWeightManager.semiBold,
        ),
        gapH8,
        TextFormField(
          initialValue: widget.initialValue,
          maxLength: widget.maxLength,
          maxLines: 1,
          obscureText: _passwordVisible,
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible
                    ? IconConstants.showPassword
                    : IconConstants.hidePassword,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
