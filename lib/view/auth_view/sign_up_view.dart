import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_app_bar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/common/widget/b_text_span.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_checkbox.dart';
import 'package:budget_app/common/widget/form/b_form_field_password.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: BAppBar(text: 'Sign up'),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // gapH24,
              gapH32,
               BText.h1(
                'WelecomeAppName!'.hardcoded,
                textAlign: TextAlign.left,
              ),
              gapH16,
               BText(
                'signUpToStart'.hardcoded,
                textAlign: TextAlign.left,
              ),
              gapH48,
              _form()
            ]),
      ),
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
            gapH16,
            _terms(),
            gapH32,
            _button(),
            gapH16,
          ],
        ));
  }

  Widget _terms() {
    return BFormCheckbox(
        validator: (p0) {
          if (p0 == false) {
            return 'Please enable our terms of service'.hardcoded;
          }
          return null;
        },
        title: BTextRich(
          BTextSpan(children: [
            BTextSpan(text: 'enableServiceDescription1'.hardcoded),
            BTextSpan(
              text: 'enableServiceDescription2'.hardcoded,
              style: BTextStyle.bodyMedium(color: ColorManager.primary),
            ),
          ]),
          maxLines: 3,
        ));
  }

  Widget _bEmailFormField() {
    return BFormFieldText(
      _emailController,
      label: 'Email'.hardcoded,
      hint: 'peter@gmail.com'.hardcoded,
      validator: (p0) => p0.validateEmail,
    );
  }

  Widget _bPasswordFormField() {
    return BFormFieldPassword(
      _confirmPasswordController,
      label: 'Password'.hardcoded,
      hint: '******'.hardcoded,
    );
  }

  Widget _bConfirmPassword() {
    return BFormFieldPassword(_passwordController,
        label: 'Confirm password'.hardcoded,
        hint: '******'.hardcoded,
        validator: (p0) => p0.validateMatchPassword(
              _confirmPasswordController.text,
            ));
  }

  Widget _button() {
    return BButton(onPressed: _onSignUp, title: 'Create'.hardcoded);
  }
}
