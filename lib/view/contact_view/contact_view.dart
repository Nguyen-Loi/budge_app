import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/social_enum.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _fabAnimationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fabAnimation;

  late final String _email = 'hi.smartbudget@gmail.com';
  late final String _phone = '+84 898 066 957';
  late final String _pathPhone = '+84898066957';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeOutBack,
    ));

    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOutBack,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mainAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _cardAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _cardAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: BText.appbar(context.loc.contactUs),
      ),
      body: AnimatedBuilder(
        animation: _mainAnimationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildHeaderSection(colors),
                      gapH32,
                      _buildContactCards(colors),
                      gapH32,
                      _buildSocialMediaSection(colors),
                      gapH32,
                      _buildQuickActionsSection(colors),
                      gapH56
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimationController,
        builder: (context, child) {
          return ScaleTransition(
            scale: _fabAnimation,
            child: FloatingActionButton.extended(
              onPressed: () => _launchEmail(),
              backgroundColor: colors.primary,
              icon: Icon(
                IconManager.email,
                color: colors.onPrimary,
              ),
              label: BText(
                context.loc.sendEmail,
                color: colors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(AppColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: colors.linearGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Hero(
            tag: "contact_avatar",
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: colors.onPrimary.withAlpha(60),
                shape: BoxShape.circle,
              ),
              child: Icon(
                IconManager.contact,
                size: 50,
                color: colors.onPrimary,
              ),
            ),
          ),
          gapH16,
          BText.h2(
            context.loc.getInTouch,
            color: colors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
          gapH8,
          BText.b1(
            context.loc.contactUsDesc,
            color: colors.onPrimary.withAlpha(210),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCards(AppColors colors) {
    AppLocalizations loc = context.loc;
    return AnimatedBuilder(
      animation: _cardAnimationController,
      builder: (context, child) {
        return Column(
          children: [
            _buildAnimatedCard(
              icon: IconManager.email,
              title: loc.emailSupport,
              subtitle: _email,
              description: loc.emailSupportDesc,
              onTap: () => _launchEmail(),
              colors: colors,
              delay: 0,
            ),
            gapH16,
            _buildAnimatedCard(
              icon: IconManager.contact,
              title: loc.phoneSupport,
              subtitle: _phone,
              description: loc.phoneSupportDesc,
              onTap: () => _launchPhone(),
              colors: colors,
              delay: 200,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
    required AppColors colors,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Card(
              elevation: 8,
              shadowColor: colors.primary.withAlpha(80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.primary.withAlpha(30),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.primary.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: colors.primary,
                          size: 24,
                        ),
                      ),
                      gapW16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BText.b1(
                              title,
                              fontWeight: FontWeight.w600,
                              color: colors.defaultText,
                            ),
                            gapH4,
                            BText(
                              subtitle,
                              color: colors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                            gapH4,
                            BText.b3(
                              description,
                              color: colors.lightText,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        IconManager.arrowNext,
                        color: colors.lightText,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialMediaSection(AppColors colors) {
    return Column(
      children: [
        BText.h3(
          context.loc.followUs,
          fontWeight: FontWeight.w600,
          color: colors.defaultText,
        ),
        gapH16,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(
              icon: IconManager.facebook,
              color: const Color(0xFF1877F2),
              onTap: () => _launchSocial(SocialEnum.facebook),
            ),
            _buildSocialButton(
              icon: IconManager.instagram,
              color: const Color(0xFFE4405F),
              onTap: () => _launchSocial(SocialEnum.instagram),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value.clamp(0.0, 1.0),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withAlpha(150)),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionsSection(AppColors colors) {
    AppLocalizations loc = context.loc;
    return Column(
      children: [
        BText.h3(
          loc.quickActions,
          fontWeight: FontWeight.w600,
          color: colors.defaultText,
        ),
        gapH16,
        Row(
          children: [
            Expanded(
              child: BButton(
                onPressed: () => _copyToClipboard(_email),
                title: loc.copyEmail,
              ),
            ),
            gapW16,
            Expanded(
              child: BButton(
                onPressed: () => _copyToClipboard(_phone),
                title: loc.copyPhone,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Action methods
  void _launchEmail() async {
    String appName = context.loc.appName;
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: _email,
      query:
          'subject=${context.loc.pSubjectContactUsEmail(appName)}&body=${context.loc.pBodyContactUsEmail(appName)}',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: _pathPhone,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _launchSocial(SocialEnum social) async {
    String url = social.url;

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showSnackBar(
      context,
      context.loc.pCopyToClipboard(text),
    );
  }
}
