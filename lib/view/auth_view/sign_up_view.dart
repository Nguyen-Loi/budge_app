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
import 'package:budget_app/localization/app_localizations_context.dart';
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
        appBar: BAppBar(text: context.loc.signUp),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // gapH24,
              gapH32,
              BText.h1(
                context.loc.welecomeAppName,
                textAlign: TextAlign.left,
              ),
              gapH16,
              BText(
                context.loc.signUpToStart,
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
            return context.loc.pleaseEnableService;
          }
          return null;
        },
        title: BTextRich(
          BTextSpan(children: [
            BTextSpan(text: context.loc.nEableServiceDescription(0)),
            BTextSpan(
              text: context.loc.nEableServiceDescription(1),
              style: BTextStyle.bodyMedium(color: ColorManager.primary),
            ),
          ]),
          maxLines: 3,
        ));
  }

  Widget _bEmailFormField() {
    return BFormFieldText(
      _emailController,
      label: context.loc.email,
      hint: context.loc.emailHint,
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
