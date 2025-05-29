import 'package:budget_app/common/widget/b_app_bar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<ForgotPasswordView> {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onResetPassword() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).resetPassword(
            context,
            email: _emailController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: BAppBar(context,text: context.loc.resetPassword),
        body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  gapH32,
                  BText.h2(
                    context.loc.resetPasswordTitle,
                    textAlign: TextAlign.left,
                  ),
                  gapH16,
                  BText(
                    context.loc.resetPasswordDescription,
                    textAlign: TextAlign.left,
                  ),
                  gapH48,
                  _form()
                ]).responsiveCenter(),
      ),
    );
  }

  Widget _form() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _bFieldEmail(),
            gapH32,
            _button(),
          ],
        ));
  }

  Widget _bFieldEmail() {
    return BFormFieldText(
      _emailController,
      label: context.loc.email,
      hint: context.loc.emailHint,
      validator: (e) => e.validateEmail(context),
    );
  }

  Widget _button() {
    return BButton(
      onPressed: _onResetPassword,
      title: context.loc.resetPassword,
    );
  }
}
