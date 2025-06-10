import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EnhancedBudgetChart extends StatefulWidget {
  final List<ChartBudgetModel> chartData;
  final bool showIncomeExpenseBreakdown;

  const EnhancedBudgetChart({
    super.key,
    required this.chartData,
    this.showIncomeExpenseBreakdown = false,
  });

  @override
  State<EnhancedBudgetChart> createState() => _EnhancedBudgetChartState();
}

class _EnhancedBudgetChartState extends State<EnhancedBudgetChart>
    with TickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Color> get modernColors {
    return [
      const Color(0xFF4F46E5), // Indigo-600
      const Color(0xFFDC2626), // Red-600
      const Color(0xFF059669), // Emerald-600
      const Color(0xFFD97706), // Amber-600
      const Color(0xFF7C3AED), // Violet-600
      const Color(0xFF0891B2), // Cyan-600
      const Color(0xFFDB2777), // Pink-600
      const Color(0xFF65A30D), // Lime-600
      const Color(0xFF0D9488), // Teal-600
      const Color(0xFFEA580C), // Orange-600
      const Color(0xFF2563EB), // Blue-600
      const Color(0xFF475569), // Slate-600
      const Color(0xFFF59E0B), // Amber-500
      const Color(0xFF10B981), // Emerald-500
      const Color(0xFF8B5CF6), // Violet-500
    ];
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.chartData;

    if (list.isEmpty) {
      return _buildEmptyState(context);
    }

    if (list.length > modernColors.length) {
      return _buildErrorState(context);
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
                        .withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).shadowColor.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color:
                        Theme.of(context).shadowColor.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, list),
                    const SizedBox(height: 24),
                    _buildChart(context, list),
                    if (widget.showIncomeExpenseBreakdown) ...[
                      const SizedBox(height: 20),
                      _buildIncomeExpenseBreakdown(context, list),
                    ],
                  ],
                ),
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
          Lottie.asset(
            LottieAssets.emptyChart,
            width: 120,
            height: 120,
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

  Widget _buildErrorState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          BText(
            "Too many categories to display",
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<ChartBudgetModel> list) {
    final totalAmount = list.fold(0, (sum, item) => sum + item.total);
    final incomeAmount = list
        .where((item) => item.total > 0)
        .fold(0, (sum, item) => sum + item.total);
    final expenseAmount = list
        .where((item) => item.total < 0)
        .fold(0, (sum, item) => sum + item.total.abs());

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
                Icons.donut_small_rounded,
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
                    "Budget Overview",
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(height: 4),
                  BText(
                    totalAmount.toMoneyStr(),
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (widget.showIncomeExpenseBreakdown &&
            (incomeAmount > 0 || expenseAmount > 0)) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              if (incomeAmount > 0) ...[
                _buildQuickStat(
                  context,
                  "Income",
                  incomeAmount.toMoneyStr(),
                  Icons.trending_up_rounded,
                  Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(width: 16),
              ],
              if (expenseAmount > 0)
                _buildQuickStat(
                  context,
                  "Expense",
                  expenseAmount.toMoneyStr(),
                  Icons.trending_down_rounded,
                  Theme.of(context).colorScheme.error,
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildQuickStat(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BText(
                    label,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                  BText(
                    value,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<ChartBudgetModel> list) {
    return AspectRatio(
      aspectRatio: 1.3,
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
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 3,
                  centerSpaceRadius: 50,
                  sections: _buildSections(list),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: ColumnWithSpacing(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildLegend(list),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseBreakdown(
      BuildContext context, List<ChartBudgetModel> list) {
    final incomeItems = list.where((item) => item.total > 0).toList();
    final expenseItems = list.where((item) => item.total < 0).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(
          "Income vs Expense Breakdown",
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (incomeItems.isNotEmpty)
              Expanded(
                child: _buildBreakdownCard(
                  context,
                  "Income",
                  incomeItems,
                  Theme.of(context).colorScheme.tertiary,
                  Icons.add_circle_outline,
                ),
              ),
            if (incomeItems.isNotEmpty && expenseItems.isNotEmpty)
              const SizedBox(width: 12),
            if (expenseItems.isNotEmpty)
              Expanded(
                child: _buildBreakdownCard(
                  context,
                  "Expenses",
                  expenseItems,
                  Theme.of(context).colorScheme.error,
                  Icons.remove_circle_outline,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildBreakdownCard(BuildContext context, String title,
      List<ChartBudgetModel> items, Color color, IconData icon) {
    final total = items.fold(0, (sum, item) => sum + item.total.abs());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              BText(
                title,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 8),
          BText(
            total.toMoneyStr(),
            fontWeight: FontWeight.w700,
            color: color,
          ),
          const SizedBox(height: 8),
          BText(
            "${items.length} categories",
            fontWeight: FontWeight.w400,
            color: color.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(List<ChartBudgetModel> list) {
    return list.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 65.0 : 55.0;
      final color = modernColors[index];

      return PieChartSectionData(
        color: color,
        value: item.value,
        title: isTouched ? '${item.value.toStringAsFixed(1)}%' : '',
        showTitle: isTouched,
        radius: radius,
        titleStyle: context.textTheme.bodyMedium!.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  item.total.abs().toMoneyStr(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();
  }

  List<Widget> _buildLegend(List<ChartBudgetModel> list) {
    return list.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final color = modernColors[index];
      final isIncome = item.total > 0;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BText(
                          item.budgetName,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Icon(
                        isIncome ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: isIncome
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BText(
                        '${item.value.toStringAsFixed(1)}%',
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                      BText(
                        item.total.abs().toMoneyStr(),
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
