import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_app_bar.dart';
import 'package:budget_app/common/widget/b_divider.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_password.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).loginWithEmailPassword(
            context,
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  void _onLoginFacebook() {
    ref.read(authControllerProvider.notifier).loginWithFacebook(
          context,
        );
  }

  void _onLoginGoogle() {
    ref.read(authControllerProvider.notifier).loginWithGoogle(
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: BAppBar(text: context.loc.signIn),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              gapH32,
              BText.h1(
                context.loc.welecomeBack,
                textAlign: TextAlign.left,
              ),
              gapH16,
              BText(
                context.loc.signInDescription,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _bFieldEmail(),
            gapH16,
            _bFieldPassword(),
            gapH8,
            _forgotPassword(),
            gapH32,
            _button(),
            gapH16,
            _orLoginWidth(),
            gapH48,
            _iconButtons()
          ],
        ));
  }

  Widget _forgotPassword() {
    return Text.rich(TextSpan(children: [
      TextSpan(text: AppLocalizations.of(context).nForgotPassword(0)),
      TextSpan(
          text: AppLocalizations.of(context).nForgotPassword(1),
          style: context.textTheme.bodyMedium),
    ]));
  }

  Widget _bFieldEmail() {
    return BFormFieldText(
      _emailController,
      label: context.loc.email,
      hint: context.loc.emailHint,
      validator: (e) => e.validateEmail(context),
    );
  }

  Widget _bFieldPassword() {
    return BFormFieldPassword(
      _passwordController,
      validator: (e) => e.validatePassword(context),
    );
  }

  Widget _button() {
    return FilledButton(
      onPressed: _onLogin,
      child: BText.b1(
        context.loc.signIn,
        color: ColorManager.white,
      ),
    );
  }

  Widget _orLoginWidth() {
    return Row(
      children: [
        const Expanded(child: BDivider.h()),
        gapW8,
        BText(context.loc.orLoginWith),
        gapW8,
        const Expanded(child: BDivider.h()),
      ],
    );
  }

  Widget _iconButtons() {
    return RowWithSpacing(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(RoutePath.signUp);
          },
          icon: SvgPicture.asset(
            SvgAssets.budget,
            width: 48,
            height: 48,
          ),
        ),
        IconButton(
          onPressed: _onLoginGoogle,
          icon: SvgPicture.asset(
            SvgAssets.google,
            width: 48,
            height: 48,
          ),
        ),
        IconButton(
          onPressed: _onLoginFacebook,
          icon: SvgPicture.asset(
            SvgAssets.facebook,
            width: 48,
            height: 48,
          ),
        ),
      ],
    );
  }
}
