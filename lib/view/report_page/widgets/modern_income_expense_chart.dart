import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/data/models/models_widget/chart_budget_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ModernIncomeExpenseChart extends StatefulWidget {
  final int totalIncome;
  final int totalExpense;
  final String period;
  final int transactionCount;
  final List<TransactionTypeEnum> transactionTypes;
  final List<ChartBudgetModel> chartData; // Add budget data for breakdown

  const ModernIncomeExpenseChart({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    this.period = '',
    this.transactionCount = 0,
    this.transactionTypes = const [
      TransactionTypeEnum.income,
      TransactionTypeEnum.expense
    ],
    this.chartData = const [], // Add budget data parameter
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
    final hasIncomeType =
        widget.transactionTypes.contains(TransactionTypeEnum.income);
    final hasExpenseType =
        widget.transactionTypes.contains(TransactionTypeEnum.expense);

    // Check if we have any data for the selected transaction types
    final effectiveTotal = hasIncomeType && hasExpenseType
        ? widget.totalIncome + widget.totalExpense
        : hasIncomeType
            ? widget.totalIncome
            : widget.totalExpense;

    if (effectiveTotal <= 0) {
      return _buildEmptyState(context);
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, hasIncomeType, hasExpenseType),
                const SizedBox(height: 24),
                // Show budget breakdown for single type, chart for mixed types
                if (hasIncomeType && hasExpenseType) ...[
                  _buildChart(context, hasIncomeType, hasExpenseType),
                  const SizedBox(height: 20),
                  _buildSummary(context, hasIncomeType, hasExpenseType),
                ] else
                  _buildBudgetBreakdown(context, hasIncomeType, hasExpenseType),
              ],
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

  Widget _buildHeader(
      BuildContext context, bool hasIncomeType, bool hasExpenseType) {
    String chartTitle;
    AppLocalizations loc = context.loc;
    if (hasIncomeType && hasExpenseType) {
      chartTitle = loc.incomeVsExpense;
    } else if (hasIncomeType) {
      chartTitle = loc.incomeAnalysis;
    } else {
      chartTitle = loc.expenseAnalysis;
    }

    final balance = widget.totalIncome - widget.totalExpense;
    final isPositive = balance >= 0;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
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
                chartTitle,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              if (widget.period.isNotEmpty)
                BText(
                  widget.period,
                ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (hasIncomeType && hasExpenseType) ...[
                    BText(
                      balance.toMoneyStr(),
                      fontWeight: FontWeight.w700,
                      color: isPositive
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 16),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChart(
      BuildContext context, bool hasIncomeType, bool hasExpenseType) {
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
                  sections:
                      _buildSections(context, hasIncomeType, hasExpenseType),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(
      BuildContext context, bool hasIncomeType, bool hasExpenseType) {
    // Calculate total for percentage calculations
    int total = 0;
    if (hasIncomeType && hasExpenseType) {
      total = widget.totalIncome + widget.totalExpense;
    } else if (hasIncomeType) {
      total = widget.totalIncome;
    } else {
      total = widget.totalExpense;
    }

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
          if (hasIncomeType) ...[
            Expanded(
              child: _buildSummaryItem(
                context,
                context.loc.totalIncome,
                widget.totalIncome.toMoneyStrTruncated(),
                hasIncomeType && hasExpenseType
                    ? "${incomePercentage.toStringAsFixed(1)}%"
                    : "100%",
                Theme.of(context).colorScheme.tertiary,
                Icons.trending_up_rounded,
              ),
            ),
            if (hasExpenseType) ...[
              Container(
                width: 1,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
              ),
            ],
          ],
          if (hasExpenseType)
            Expanded(
              child: _buildSummaryItem(
                context,
                context.loc.totalExpense,
                widget.totalExpense.toMoneyStrTruncated(),
                hasIncomeType && hasExpenseType
                    ? "${expensePercentage.toStringAsFixed(1)}%"
                    : "100%",
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
            BText.b3(
              label,
              fontWeight: FontWeight.w700,
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

  List<PieChartSectionData> _buildSections(
      BuildContext context, bool hasIncomeType, bool hasExpenseType) {
    List<PieChartSectionData> sections = [];

    // Calculate total for percentage calculations
    int total = 0;
    if (hasIncomeType && hasExpenseType) {
      total = widget.totalIncome + widget.totalExpense;
    } else if (hasIncomeType) {
      total = widget.totalIncome;
    } else {
      total = widget.totalExpense;
    }

    if (hasIncomeType && widget.totalIncome > 0) {
      final incomePercentage = (widget.totalIncome / total) * 100;
      sections.add(_buildSection(
        value: incomePercentage,
        index: 0,
        color: Theme.of(context).colorScheme.tertiary,
      ));
    }

    if (hasExpenseType && widget.totalExpense > 0) {
      final expensePercentage = (widget.totalExpense / total) * 100;
      sections.add(_buildSection(
        value: expensePercentage,
        index: hasIncomeType ? 1 : 0,
        color: Theme.of(context).colorScheme.error,
      ));
    }

    return sections;
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

  Widget _buildBudgetBreakdown(
      BuildContext context, bool hasIncomeType, bool hasExpenseType) {
    if (widget.chartData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary section
        Container(
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
              if (hasIncomeType) ...[
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    context.loc.totalIncome,
                    widget.totalIncome.toMoneyStr(),
                    "100%",
                    Theme.of(context).colorScheme.tertiary,
                    Icons.trending_up_rounded,
                  ),
                ),
              ],
              if (hasExpenseType) ...[
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    context.loc.totalExpense,
                    widget.totalExpense.toMoneyStr(),
                    "100%",
                    Theme.of(context).colorScheme.error,
                    Icons.trending_down_rounded,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Budget breakdown list
        BText(
          context.loc.budgetBreakdown,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(height: 16),

        // Horizontal scrollable budget list
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.chartData.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final color = modernColors[index % modernColors.length];

              bool isIncome = false;
              if (hasIncomeType && !hasExpenseType) {
                isIncome = true;
              } else if (!hasIncomeType && hasExpenseType) {
                isIncome = false;
              } else {
                isIncome = item.total > 0;
              }

              // Calculate percentage of the total for this type
              final total =
                  hasIncomeType ? widget.totalIncome : widget.totalExpense;
              final percentage =
                  total > 0 ? (item.total.abs() / total) * 100 : 0;

              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: color.withValues(alpha: 0.1),
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
                        Expanded(
                          child: BText(
                            item.budgetName,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                    const SizedBox(height: 8),
                    BText(
                      '${percentage.toStringAsFixed(1)}%',
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
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
