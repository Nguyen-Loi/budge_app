import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ModernIncomeExpenseChart extends StatefulWidget {
  final int totalIncome;
  final int totalExpense;
  final String period;

  const ModernIncomeExpenseChart({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    this.period = '',
  });

  @override
  State<ModernIncomeExpenseChart> createState() =>
      _ModernIncomeExpenseChartState();
}

class _ModernIncomeExpenseChartState extends State<ModernIncomeExpenseChart>
    with TickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.totalIncome + widget.totalExpense;

    if (total <= 0) {
      return _buildEmptyState(context);
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildChart(context),
                  const SizedBox(height: 20),
                  _buildSummary(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.analytics_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),
          BText(
            context.loc.noData,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final balance = widget.totalIncome - widget.totalExpense;
    final isPositive = balance >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BText(
                    "Income vs Expense${widget.period.isNotEmpty ? ' - ${widget.period}' : ''}",
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      BText(
                        "Balance: ",
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      BText(
                        balance.toMoneyStr(),
                        fontWeight: FontWeight.w700,
                        color: isPositive
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sectionsSpace: 4,
                  centerSpaceRadius: 45,
                  borderData: FlBorderData(show: false),
                  sections: _buildSections(context),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicators(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final total = widget.totalIncome + widget.totalExpense;
    final incomePercentage = total > 0 ? (widget.totalIncome / total) * 100 : 0;
    final expensePercentage =
        total > 0 ? (widget.totalExpense / total) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              context,
              "Total Income",
              widget.totalIncome.toMoneyStr(),
              "${incomePercentage.toStringAsFixed(1)}%",
              Theme.of(context).colorScheme.tertiary,
              Icons.trending_up_rounded,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildSummaryItem(
              context,
              "Total Expense",
              widget.totalExpense.toMoneyStr(),
              "${expensePercentage.toStringAsFixed(1)}%",
              Theme.of(context).colorScheme.error,
              Icons.trending_down_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String amount,
      String percentage, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            BText(
              label,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ],
        ),
        const SizedBox(height: 4),
        BText(
          amount,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        BText(
          percentage,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(BuildContext context) {
    final total = widget.totalIncome + widget.totalExpense;
    final incomePercentage = (widget.totalIncome / total) * 100;
    final expensePercentage = (widget.totalExpense / total) * 100;

    return [
      _buildSection(
        value: incomePercentage,
        index: 0,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      _buildSection(
        value: expensePercentage,
        index: 1,
        color: Theme.of(context).colorScheme.error,
      ),
    ];
  }

  PieChartSectionData _buildSection({
    required double value,
    required int index,
    required Color color,
  }) {
    final isTouched = index == touchedIndex;
    final radius = isTouched ? 65.0 : 55.0;

    return PieChartSectionData(
      color: color,
      value: value,
      title: isTouched ? '${value.toStringAsFixed(1)}%' : '',
      showTitle: isTouched,
      radius: radius,
      titleStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color,
          color.withValues(alpha: 0.8),
        ],
      ),
    );
  }

  List<Widget> _buildIndicators(BuildContext context) {
    final total = widget.totalIncome + widget.totalExpense;
    final incomePercentage = (widget.totalIncome / total) * 100;
    final expensePercentage = (widget.totalExpense / total) * 100;

    return [
      _buildIndicator(
        context,
        Theme.of(context).colorScheme.tertiary,
        "Income",
        "${incomePercentage.toStringAsFixed(1)}%",
        widget.totalIncome.toMoneyStr(),
      ),
      const SizedBox(height: 16),
      _buildIndicator(
        context,
        Theme.of(context).colorScheme.error,
        "Expense",
        "${expensePercentage.toStringAsFixed(1)}%",
        widget.totalExpense.toMoneyStr(),
      ),
    ];
  }

  Widget _buildIndicator(BuildContext context, Color color, String label,
      String percentage, String amount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              BText(
                label,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 4),
          BText(
            percentage,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          BText(
            amount,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
