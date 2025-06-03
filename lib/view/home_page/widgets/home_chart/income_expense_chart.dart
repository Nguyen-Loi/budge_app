import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeExpenseChart extends StatefulWidget {
  final double totalIncome;
  final double totalExpense;

  const IncomeExpenseChart({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  State<IncomeExpenseChart> createState() => _IncomeExpenseChartState();
}

class _IncomeExpenseChartState extends State<IncomeExpenseChart> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final total = widget.totalIncome + widget.totalExpense;

    if (total <= 0) {
      return Column(
        children: [
          Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 2,
              ),
            ),
            child: Center(
              child: BText(
                context.loc.noData,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          BText(context.loc.noData)
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
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
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sectionsSpace: 2,
                centerSpaceRadius: 32,
                borderData: FlBorderData(
                  show: false,
                ),
                sections: _showingSections(context),
              ),
            ),
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _buildIndicators(context),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _showingSections(BuildContext context) {
    final incomePercentage =
        (widget.totalIncome / (widget.totalIncome + widget.totalExpense)) * 100;
    final expensePercentage =
        (widget.totalExpense / (widget.totalIncome + widget.totalExpense)) *
            100;

    return [
      _itemChart(
        value: incomePercentage,
        index: 0,
        colour: Theme.of(context).colorScheme.tertiary,
      ),
      _itemChart(
        value: expensePercentage,
        index: 1,
        colour: Theme.of(context).colorScheme.error,
      ),
    ];
  }

  PieChartSectionData _itemChart(
      {required double value, required int index, required Color colour}) {
    final isTouched = index == touchedIndex;
    final fontSize = isTouched ? 18.0 : 0.0;
    final radius = isTouched ? 60.0 : 50.0;
    final showTitle = isTouched;

    return PieChartSectionData(
      color: colour,
      value: value,
      title: showTitle ? '${value.toStringAsFixed(1)}%' : '',
      showTitle: showTitle,
      radius: radius,
      titleStyle: context.textTheme.bodyLarge!.copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  List<Widget> _buildIndicators(BuildContext context) {
    final incomePercentage =
        (widget.totalIncome / (widget.totalIncome + widget.totalExpense)) * 100;
    final expensePercentage =
        (widget.totalExpense / (widget.totalIncome + widget.totalExpense)) *
            100;

    return [
      _Indicator(
        color: Theme.of(context).colorScheme.tertiary,
        text: 'Income (${incomePercentage.toStringAsFixed(1)}%)',
        isSquare: true,
      ),
      const SizedBox(height: 4),
      _Indicator(
        color: Theme.of(context).colorScheme.error,
        text: 'Expense (${expensePercentage.toStringAsFixed(1)}%)',
        isSquare: true,
      ),
    ];
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.color,
    required this.text,
    required this.isSquare,
  });

  final Color color;
  final String text;
  final bool isSquare;

  final double size = 16;

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
        const SizedBox(width: 4),
        Flexible(
          child: BText.b3(
            text,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
