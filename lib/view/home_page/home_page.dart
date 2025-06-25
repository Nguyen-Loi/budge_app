import 'package:budget_app/common/mixin/floating_action_transaction_mixin.dart';
import 'package:budget_app/common/widget/b_avatar_profile.dart';
import 'package:budget_app/common/widget/b_divider.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/demo/button_demo_page.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/budget_view/widget/budget_card.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:budget_app/view/home_page/home_drawer.dart';
import 'package:budget_app/view/home_page/widgets/home_chart/income_expense_chart.dart';
import 'package:budget_app/view/home_page/widgets/home_wallet_card.dart';
import 'package:budget_app/view/transactions_view/widget/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToTransactions;
  final VoidCallback? onNavigateToBudgets;

  const HomePage(
      {super.key, this.onNavigateToTransactions, this.onNavigateToBudgets});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with FloatingActionMixin, TickerProviderStateMixin {
  late AnimationController _drawerController;
  late Animation<double> _drawerAnimation;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _drawerAnimation = CurvedAnimation(
      parent: _drawerController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(drawerAnimation: _drawerAnimation),
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                HomeWalletCard(),
                gapH24,
                _buildIncomeExpenseSection(),
                gapH24,
                _buildBudgetSection(),
                gapH24,
                _buildRecentTransactionsSection(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: false,
      automaticallyImplyLeading: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: _drawerAnimation.value * 0.5,
            child: Icon(
              Icons.menu_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
            _drawerController.forward();
          },
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Consumer(builder: (_, ref, __) {
          final UserModel user = ref.watch(userBaseControllerProvider);
          return Container(
            padding: const EdgeInsets.fromLTRB(72, 50, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BText(
                        context.loc.hello,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withAlpha(100),
                      ),
                      BText.h3(
                        user.name,
                        color: Theme.of(context).colorScheme.onPrimary,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ButtonDemoPage()));
                    },
                    child: BAvatarProfile(
                        url: user.profileUrl, username: user.name)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildIncomeExpenseSection() {
    Color sucessColor = Theme.of(context).colorScheme.tertiary;
    Color errorColor = Theme.of(context).colorScheme.error;
    Color backgroundColor = Theme.of(context).colorScheme.surface;

    return Consumer(builder: (_, ref, __) {
      final homeController = ref.watch(homeControllerProvider.notifier);
      final totalIncome = homeController.totalIncomeThisMonth;
      final totalExpense = homeController.totalExpenseThisMonth.abs();
      bool isNoData = totalIncome == 0 && totalExpense == 0;

      return _buildSection(
          title: context.loc.incomeExpenseThisMonth,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor.withAlpha(240),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: 0.1,
                      ),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BText.b3(
                            context.loc.totalRevenue,
                            color: sucessColor.withAlpha(200),
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 4),
                          BText.h3(
                            totalIncome.toMoneyStr(ref),
                            color: sucessColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 40,
                        child: BDivider.v(
                          color: Theme.of(context).dividerColor.withAlpha(100),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BText.b3(
                            context.loc.totalCost,
                            color: errorColor.withAlpha(200),
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 4),
                          BText.h3(
                            totalExpense.toMoneyStr(ref),
                            color: errorColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isNoData) gapH32,
                if (!isNoData)
                  IncomeExpenseChart(
                    totalIncome: totalIncome,
                    totalExpense: totalExpense,
                  )
              ],
            ),
          ));
    });
  }

  Widget _buildSection(
      {required String title,
      required Widget child,
      void Function()? onTap,
      bool viewAll = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: BText.b1(
                title.toUpperCase(),
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onTap != null && viewAll)
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      BText(
                        context.loc.viewAll,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        IconManager.arrowNext,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
        gapH8,
        child,
      ],
    );
  }

  Widget _buildBudgetSection() {
    return Consumer(builder: (_, ref, __) {
      final budgets = ref.watch(homeControllerProvider.notifier).budgetsPreview;
      return _buildSection(
          title: context.loc.budget,
          viewAll: budgets.isNotEmpty,
          onTap: widget.onNavigateToBudgets,
          child: budgets.isNotEmpty
              ? ColumnWithSpacing(
                  children: budgets
                      .map((budget) => BudgetCard(
                            model: budget,
                            isPreview: true,
                          ))
                      .toList(),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: BText(
                      context.loc.noBudgetsAvailable,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(150),
                    ),
                  ),
                ));
    });
  }

  Widget _buildRecentTransactionsSection() {
    return Consumer(builder: (_, ref, __) {
      final transactions =
          ref.watch(homeControllerProvider.notifier).transactionsRecently;
      return _buildSection(
          title: context.loc.recentTransactions,
          viewAll: transactions.isNotEmpty,
          onTap: widget.onNavigateToTransactions,
          child: transactions.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: BText(
                      context.loc.noRecentTransactions,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(150),
                    ),
                  ),
                )
              : ColumnWithSpacing(
                  children: transactions
                      .map((e) => TransactionCard(
                            model: e,
                          ))
                      .toList(),
                ));
    });
  }
}
