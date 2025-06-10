import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:budget_app/core/extension/extension_money.dart';

class ChartReport extends StatefulWidget {
  const ChartReport({super.key, required this.list});
  final List<ChartBudgetModel> list;

  @override
  State<ChartReport> createState() => _ChartReportState();
}

class _ChartReportState extends State<ChartReport>
    with TickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Color> get colorsChart {
    return [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFFEF4444), // Red
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF8B5CF6), // Violet
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFEC4899), // Pink
      const Color(0xFF84CC16), // Lime
      const Color(0xFF14B8A6), // Teal
      const Color(0xFFF97316), // Orange
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF64748B), // Slate
      const Color(0xFFDC2626), // Red-600
      const Color(0xFF059669), // Emerald-600
      const Color(0xFF7C3AED), // Violet-600
    ];
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.list;
    if (list.length > colorsChart.length) {
      return const SizedBox.shrink();
    }
    if (list.isEmpty) {
      return Column(
        children: [
          Lottie.asset(LottieAssets.emptyChart, width: 160, height: 160),
          gapH16,
          BText(context.loc.noData)
        ],
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, list),
            const SizedBox(height: 20),
            _buildChart(context, list),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<ChartBudgetModel> list) {
    final totalAmount = list.fold(0, (sum, item) => sum + item.total);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.donut_small_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BText(
                "Budget Distribution",
                fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildChart(BuildContext context, List<ChartBudgetModel> list) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Row(
        children: <Widget>[
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
                  sectionsSpace: 2,
                  centerSpaceRadius: 45,
                  sections: showingSections(list),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: ColumnWithSpacing(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _informations(list),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PieChartSectionData _itemChart(
      {required ChartBudgetModel model, required int index}) {
    final isTouched = index == touchedIndex;
    final radius = isTouched ? 60.0 : 50.0;
    final colour = colorsChart[index];

    double value = model.value;
    return PieChartSectionData(
      color: colour,
      value: value,
      title: isTouched ? '${value.toStringAsFixed(1)}%' : '',
      showTitle: isTouched,
      radius: radius,
      titleStyle: context.textTheme.bodyLarge!.copyWith(
        fontSize: isTouched ? 14.0 : 12.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  List<Widget> _informations(List<ChartBudgetModel> list) {
    int index = -1;
    return list.map((e) {
      index++;
      Color colour = colorsChart[index];
      return Indicator(
        color: colour,
        text: '${e.budgetName}\n(${e.value.toStringAsFixed(1)}%)',
        isSquare: true,
      );
    }).toList();
  }

  List<PieChartSectionData> showingSections(List<ChartBudgetModel> list) {
    int index = -1;
    return list.map((e) {
      index++;
      return _itemChart(model: e, index: index);
    }).toList();
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        )
      ],
    );
  }
}
