import 'package:budget_app/common/widget/b_avatar_profile.dart';
import 'package:budget_app/common/widget/b_divider.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/budget_view/widget/budget_card.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:budget_app/view/home_page/home_transactions_recently.dart';
import 'package:budget_app/view/home_page/widgets/home_chart/home_chart.dart';
import 'package:budget_app/view/home_page/widgets/home_chart/income_expense_chart.dart';
import 'package:budget_app/view/home_page/widgets/home_update_wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                HomeUpdateWalletCard(),
                gapH24,
                _buildIncomeExpenseSection(),
                gapH24,
                _buildBudgetSection(),
                gapH24,
                _buildRecentTransactionsSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Consumer(builder: (_, ref, __) {
      final UserModel user = ref.watch(userBaseControllerProvider);
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BText(
                  context.loc.hello,
                  color: Theme.of(context).dividerColor,
                ),
                BText.h3(
                  user.name,
                ),
              ],
            ),
            BAvatarProfile(url: user.profileUrl, username: user.name),
          ],
        ),
      );
    });
  }

  Widget _buildIncomeExpenseSection() {
    Color sucessColor = Theme.of(context).colorScheme.tertiary;
    Color errorColor = Theme.of(context).colorScheme.error;
    Color backgroundColor = Theme.of(context).colorScheme.surface;

    return Consumer(builder: (_, ref, __) {
      final homeController = ref.watch(homeControllerProvider.notifier);
      final totalIncome = homeController.totalIncomeThisMonth;
      final totalExpense = homeController.totalExpenseThisMonth.abs();

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
                            totalIncome.toMoneyStr(),
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
                            totalExpense.toMoneyStr(),
                            color: errorColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                gapH32,
                IncomeExpenseChart(
                  totalIncome: totalIncome,
                  totalExpense: totalExpense,
                ),
              ],
            ),
          ));
    });
  }

  Widget _buildSection(
      {required String title, required Widget child, void Function()? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BText.b1(
              title.toUpperCase(),
            ),
            if (onTap != null)
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
    return _buildSection(
      title: context.loc.budget,
      child: Consumer(builder: (_, ref, __) {
        final budgets =
            ref.watch(homeControllerProvider.notifier).budgetsPreview;
        if (budgets.isEmpty) {
          return Center(
            child: BText(
              context.loc.noBudgetsAvailable,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            ),
          );
        }
        return ColumnWithSpacing(
          children: budgets
              .map((budget) => BudgetCard(
                    model: budget,
                    isPreview: true,
                  ))
              .toList(),
        );
      }),
      onTap: () {
        Navigator.pushNamed(context, '/budget');
      },
    );
  }

  Widget _buildRecentTransactionsSection() {
    return _buildSection(
      title: context.loc.recentTransactions,
      child: HomeTransactionsRecently(),
      onTap: () {
        Navigator.pushNamed(context, '/transactions');
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            BDialogInfo(
              message: context.loc.developingFreatures,
              dialogInfoType: BDialogInfoType.warning,
            ).present(context);
          },
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
