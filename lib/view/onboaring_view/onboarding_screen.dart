import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/enums/language_enum.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/currency_base_controller.dart';
import 'package:budget_app/view/onboaring_view/widgets/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingResult {
  final String userName;
  final CurrencyType currency;

  OnboardingResult({required this.userName, required this.currency});
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentPage = 0;
  final int _totalPages = 3;

  // Form data
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late CurrencyType _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _nameController = TextEditingController();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Initialize currency
    LanguageEnum language = ref.read(languageControllerProvider);
    _selectedCurrency = CurrencyType.fromLanguage(language);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextPage() {
    FocusScope.of(context).unfocus();

    if (_currentPage < _totalPages - 1) {
      if (_currentPage == 1) {
        if (!_formKey.currentState!.validate()) {
          return;
        }
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    FocusScope.of(context).unfocus();

    if (_currentPage > 0) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _completeOnboarding() {
    String userName = _nameController.text.trim();
    final result = OnboardingResult(
      userName: userName.isNotEmpty ? userName : context.loc.userNameDefault,
      currency: _selectedCurrency,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: Stack(
          children: [
            FloatingParticles(
              color: Theme.of(context).colorScheme.primary.withAlpha(100),
              numberOfParticles: 15,
            ),
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                            // Dismiss keyboard when changing pages
                            FocusScope.of(context).unfocus();
                          },
                          children: [
                            _buildWelcomePage(),
                            _buildPersonalizationPage(),
                            _buildCurrencyPage(),
                          ],
                        ),
                      ),
                      _buildBottomSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            IconButton(
              onPressed: _previousPage,
              icon: Icon(
                IconManager.back,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          Expanded(
            child: Center(
              child: _buildPageIndicator(),
            ),
          ),
          SizedBox(
            width: _currentPage > 0 ? 48 : 0,
            height: _currentPage > 0 ? 0 : 48,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalPages, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withAlpha(150),
          ),
        );
      }),
    );
  }

  Widget _buildWelcomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              200, // Account for header and bottom
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Top spacing
            Hero(
              tag: 'app_logo',
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withAlpha(160),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(80),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  IconManager.budget,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            gapH32,
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  BText.h1(
                    context.loc.welecomeAppName,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  gapH16,
                  BText.b1(
                    context.loc.takeControlOfYourFinances,
                    textAlign: TextAlign.center,
                    color:
                        Theme.of(context).colorScheme.onPrimary.withAlpha(160),
                  ),
                ],
              ),
            ),
            gapH48,
            _buildFeaturesList(),
            const SizedBox(height: 40), // Bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    AppLocalizations loc = context.loc;
    final features = [
      {'icon': IconManager.budget, 'text': loc.smartBudgetPlanning},
      {'icon': IconManager.transactionBar, 'text': loc.easyExpenseTracking},
      {'icon': IconManager.reportBar, 'text': loc.detailedReports},
    ];

    return Column(
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 800 + (index * 200)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(50 * (1 - value), 0),
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(50),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
                gapW16,
                Expanded(
                  child: BText.b1(
                    feature['text'] as String,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPersonalizationPage() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.secondary.withAlpha(150),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.secondary.withAlpha(80),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  IconManager.account,
                  size: 50,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              gapH32,
              BText.h2(
                context.loc.letPersonalizeYourExperience,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              gapH8,
              BText.b1(
                context.loc.tellUsYourNameToGetStarted,
                textAlign: TextAlign.center,
                color: Theme.of(context).colorScheme.onPrimary.withAlpha(160),
              ),
              gapH32,
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSecondary.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      return value.validateName(context);
                    },
                    decoration: InputDecoration(
                      labelText: context.loc.name,
                      prefixIcon: Icon(
                        IconManager.account,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withAlpha(160),
                      ),
                      hintText: context.loc.enterYourName,
                      filled: false,
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withAlpha(160),
                              ),
                      labelStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withAlpha(160),
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withAlpha(80),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Bottom spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              200, // Account for header and bottom
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Top spacing
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.tertiary,
                    Theme.of(context).colorScheme.tertiary.withAlpha(150),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.tertiary.withAlpha(30),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                IconManager.budget,
                size: 50,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            gapH32,
            BText.h2(
              context.loc.chooseYourCurrency,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            gapH8,
            BText.b1(
              context.loc.selectCurrencyDesc,
              textAlign: TextAlign.center,
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(180),
            ),
            gapH32,
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: _buildCurrencySelection(),
            ),
            const SizedBox(height: 40), // Bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelection() {
    final currencyManager = ref.watch(currencyManagerProvider);
    final supportedCurrencies = currencyManager.getSupportedCurrencies();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CurrencyType>(
          value: _selectedCurrency,
          isExpanded: true,
          icon: Icon(
            IconManager.dropdown,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          borderRadius: BorderRadius.circular(20),
          items: supportedCurrencies.map((currency) {
            return DropdownMenuItem<CurrencyType>(
              value: currency,
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 35,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withAlpha(150),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: BText.b1(
                        currency.symbol,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  gapW16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BText.b1(
                          currency.code,
                          fontWeight: FontWeight.w600,
                        ),
                        BText.caption(
                          currency.getDisplayName(context),
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withAlpha(160),
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (CurrencyType? newCurrency) {
            if (newCurrency != null) {
              setState(() {
                _selectedCurrency = newCurrency;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_currentPage == 0) ...[
            BText.caption(
              context.loc.agreeToTerms,
              textAlign: TextAlign.center,
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(160),
            ),
            gapH16,
          ],
          SizedBox(
            width: double.infinity,
            child: Hero(
              tag: 'continue_button',
              child: BButton(
                onPressed: _nextPage,
                title: _currentPage == _totalPages - 1
                    ? context.loc.continueText
                    : context.loc.next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
