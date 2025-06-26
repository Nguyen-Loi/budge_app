import 'package:budget_app/common/widget/b_divider.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/form/b_form_field_password.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/auth_view/base_auth_view.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart';

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
      child: BaseAuthView(title: context.loc.signIn, children: [
        BText.h3(
          context.loc.welecomeBack,
          textAlign: TextAlign.center,
        ),
        gapH16,
        BText(
          context.loc.signInDescription,
          textAlign: TextAlign.center,
        ),
        gapH48,
        _form(),
      ]),
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
            gapH48,
            _orLoginWidth(),
            gapH40,
            _iconButtons(),
            if (!kIsWeb) ...[gapH32, _signInWithGuest()]
          ],
        ));
  }

  Widget _forgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: BButton.text(
          onPressed: () {
            Navigator.pushNamed(context, RoutePath.forgotPassword);
          },
          title: context.loc.forgetPassword),
    );
  }

  Widget _bFieldEmail() {
    return BFormFieldText(
      _emailController,
      label: context.loc.email,
      hint: context.loc.emailHint,
      prefixIcon: IconManager.email,
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
    return BButton(
      onPressed: _onLogin,
      title: context.loc.signIn,
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
    bool isMobile = !kIsWeb;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circularIconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(RoutePath.signUp);
          },
          icon: SvgPicture.asset(
            SvgAssets.iconApp,
            width: 28,
            height: 28,
          ),
        ),
        if (isMobile) ...[
          const SizedBox(width: 24),
          _circularIconButton(
            onPressed: _onLoginGoogle,
            icon: SvgPicture.asset(
              SvgAssets.google,
              width: 28,
              height: 28,
            ),
          ),
        ],
        if (isMobile) ...[
          const SizedBox(width: 24),
          _circularIconButton(
            onPressed: _onLoginFacebook,
            icon: Icon(
              IconManager.facebook,
              size: 28,
            ),
          ),
        ],
      ],
    );
  }

  Widget _circularIconButton({
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    Color color = Theme.of(context).colorScheme.onPrimary.withAlpha(150);
    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }

  Widget _signInWithGuest() {
    return Align(
      alignment: Alignment.center,
      child: BButton.text(
        onPressed: () {
          Navigator.pop(context);
        },
        title: context.loc.skip,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
