import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_field_password.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/auth_view/base_auth_view.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<SignUpView> {
  late final TextEditingController _emailController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  void _onSignUp() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).signUp(
            context,
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseAuthView(
      title: context.loc.signUp,
      children: [
        BText.h3(
          context.loc.welecomeAppName,
          textAlign: TextAlign.center,
        ),
        gapH16,
        BText(
          context.loc.signUpToStart,
          textAlign: TextAlign.center,
        ),
        gapH48,
        _form(),
        gapH64,
        _button(),
      ],
    );
  }

  Widget _form() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            _bEmailFormField(),
            gapH16,
            _bPasswordFormField(),
            gapH16,
            _bConfirmPassword(),
            // gapH16,
            // _terms(),
          ],
        ));
  }

  Widget _bEmailFormField() {
    return BFormFieldText(
      _emailController,
      label: context.loc.email,
      hint: context.loc.emailHint,
      prefixIcon: IconManager.email,
      validator: (p0) => p0.validateEmail(context),
    );
  }

  Widget _bPasswordFormField() {
    return BFormFieldPassword(
      _confirmPasswordController,
      label: context.loc.password,
      hint: context.loc.passwordHint,
      validator: (p0) => p0.validatePassword(context),
    );
  }

  Widget _bConfirmPassword() {
    return BFormFieldPassword(_passwordController,
        label: context.loc.confirmPassword,
        hint: context.loc.passwordHint,
        validator: (p0) => p0.validateMatchPassword(
              context,
              otherPassword: _confirmPasswordController.text,
            ));
  }

  Widget _button() {
    return BButton(onPressed: _onSignUp, title: context.loc.create);
  }
}
