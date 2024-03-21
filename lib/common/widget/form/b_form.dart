import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:flutter/material.dart';

class BForm extends StatelessWidget {
  BForm(
      {Key? key,
      required this.children,
      this.spacing = 16,
      this.isScroll = true,
      required this.onSubmit,
      required this.titleSubmit,
      this.spacingButton = 40})
      : super(key: key) {
    children.add(SizedBox(height: spacingButton));
  }
  final List<Widget> children;
  final double spacing;
  final bool isScroll;
  final String titleSubmit;
  final VoidCallback? onSubmit;
  final double spacingButton;

  final _formKey = GlobalKey<FormState>();

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      onSubmit?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: isScroll ? _list(context) : _column(context),
    );
  }

  Widget _list(BuildContext context) {
    return ListViewWithSpacing(
      spacing: spacing,
      children: [
        ...children,
        _button(context),
      ],
    );
  }

  Widget _column(BuildContext context) {
    return ColumnWithSpacing(
      spacing: spacing,
      children: [
        ...children,
        _button(context),
      ],
    );
  }

  Widget _button(BuildContext context) {
    return BButton(
      onPressed: () => _onSubmit(context),
      title: titleSubmit,
    );
  }
}
