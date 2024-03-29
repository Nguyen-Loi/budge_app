import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_app_bar.dart';
import 'package:budget_app/common/widget/b_divider.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/common/widget/b_text_span.dart';
import 'package:budget_app/common/widget/form/b_form_field_password.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/features/auth/view/sign_up_view.dart';
import 'package:budget_app/features/main_page_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      appBar: BAppBar(text: 'Sign in'),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            // gapH24,
            gapH32,
            const BText.h1(
              'Welecome back!',
              textAlign: TextAlign.left,
            ),
            gapH16,
            const BText(
              'Hey you\'re back, fill in your details to get back in',
              textAlign: TextAlign.left,
            ),
            gapH48,
            _bTextFormField(),
            gapH16,
            _bTextFormFieldPassword(),
            gapH8,
            _forgotPassword(),
            gapH32,
            _button(),
            gapH16,
            _orLoginWidth(),
            gapH48,
            _iconButtons()
          ]),
    );
  }

  Widget _forgotPassword() {
    return BTextRich(
      BTextSpan(children: [
        BTextSpan(text: 'Forgot '),
        BTextSpan(
          text: 'Password?',
          style: BTextStyle.bodyMedium(color: ColorManager.primary),
        ),
      ]),
      textAlign: TextAlign.end,
    );
  }

  Widget _bTextFormField() {
    return BFormFieldText(_emailController, label: 'Email');
  }

  Widget _bTextFormFieldPassword() {
    return BFormFieldPassword(_passwordController);
  }

  Widget _button() {
    return FilledButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MainPageBottomBar(),
          ),
        );
      },
      child: BText.b1(
        'Sign In',
        color: ColorManager.white,
      ),
    );
  }

  Widget _orLoginWidth() {
    return const Row(
      children: [
        Expanded(child: BDivider.h()),
        gapW8,
        BText('Or login with'),
        gapW8,
        Expanded(child: BDivider.h()),
      ],
    );
  }

  Widget _iconButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SignUpView(),
              ),
            );
          },
          icon: SvgPicture.asset(
            AssetsConstants.iconGoogle,
            width: 48,
            height: 48,
          ),
        ),
        gapW32,
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            AssetsConstants.iconFacebook,
            placeholderBuilder: (BuildContext context) => Container(
              padding: const EdgeInsets.all(30.0),
              child: const CircularProgressIndicator(),
            ),
            width: 48,
            height: 48,
          ),
        ),
      ],
    );
  }
}
