import 'package:budget_app/common/widget/b_app_bar.dart';
import 'package:budget_app/common/widget/b_divider.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/color_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(text: 'Sign up'),
      body: ListView(children: [
        // gapH24,
        const BText.h1('Welecome back!'),
        gapH16,
        const BText('Hey you\'re back, fill in your details to get back in'),
        gapH32,
        _bTextFormField(),
        gapH32,
        _bTextFormField(),
        const BText(
          'Forget password',
          textAlign: TextAlign.right,
        ),
        gapH32,
        _button(),
        gapH16,
        _orLoginWidth(),
        gapH32,
        _iconButtons()
      ]),
    );
  }

  Widget _bTextFormField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
          label: const BText('Email'),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.darkGrey))),
    );
  }

  Widget _button() {
    return FilledButton(
      onPressed: () {},
      child: const Text('Enabled'),
    );
  }

  Widget _orLoginWidth() {
    return const Row(
      children: [
        Expanded(child: BDivider.h()),
        BText('Or login with'),
        Expanded(child: BDivider.h()),
      ],
    );
  }

  Widget _iconButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.abc)),
        gapW16,
        IconButton(onPressed: () {}, icon: const Icon(Icons.abc)),
        gapW16,
        IconButton(onPressed: () {}, icon: const Icon(Icons.abc)),
      ],
    );
  }
}
