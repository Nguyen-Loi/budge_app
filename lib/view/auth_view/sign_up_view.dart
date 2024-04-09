import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_app_bar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/common/widget/b_text_span.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_field_password.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';
class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<SignUpView> {
  late final TextEditingController _emailController;
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(text: 'Sign up'),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            // gapH24,
            gapH32,
            const BText.h1(
              'Welecome to PocketPenny!',
              textAlign: TextAlign.left,
            ),
            gapH16,
            const BText(
              'Complete then sign up to get started',
              textAlign: TextAlign.left,
            ),
            gapH48,
            _bNameFormField(),
            gapH16,
            _bEmailFormField(),
            gapH16,
            _bTextFormFieldPassword(),
            gapH16,
            _terms(),
            gapH32,
            _button(),
            gapH16,
          ]),
    );
  }

  Widget _terms() {
    return Row(
      children: [
        Checkbox(value: true, onChanged: (_) => {}),
        gapW16,
        Flexible(
          child: BTextRich(
            BTextSpan(children: [
              BTextSpan(text: 'By the signing up, you agree to the  '),
              BTextSpan(
                text: 'Terms of Service and Privay Policy',
                style: BTextStyle.bodyMedium(color: ColorManager.primary),
              ),
            ]),
            maxLines: 3,
          ),
        )
      ],
    );
  }

  Widget _bEmailFormField() {
    return BFormFieldText(
      _emailController,
      label: 'Email',
      hint: 'Entert your email',
    );
  }

  Widget _bNameFormField() {
    return BFormFieldText(
      _nameController,
      label: 'Name',
      hint: 'Enter your name',
    );
  }

  Widget _bTextFormFieldPassword() {
    return BFormFieldPassword(_passwordController);
  }

  Widget _button() {
    return BButton(onPressed: () {}, title: 'Create');
  }
}
