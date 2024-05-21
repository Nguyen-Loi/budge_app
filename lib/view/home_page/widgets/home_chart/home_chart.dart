import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:budget_app/view/home_page/widgets/home_chart/controller/home_chart_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeChart extends ConsumerStatefulWidget {
  const HomeChart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeChartState();
}

class HomeChartState extends ConsumerState<HomeChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<ChartBudgetModel> list = ref.watch(homeChartStateControllerProvider);
    return list.isEmpty
        ? const SizedBox.shrink()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BText('Tuần này'.hardcoded),
                  TextButton(
                    child: BText('Xem tất cả'.hardcoded),
                    onPressed: () {},
                  ),
                ],
              ),
              AspectRatio(
                aspectRatio: 1.3,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
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
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections(list),
                          ),
                        ),
                      ),
                    ),
                    ColumnWithSpacing(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _informations(list),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  PieChartSectionData _itemChart(
      {required ChartBudgetModel model, required int index}) {
    final isTouched = index == touchedIndex;
    final fontSize = isTouched ? 25.0 : 16.0;
    final radius = isTouched ? 60.0 : 50.0;
    final colour = IconManagerData.getIconModel(model.iconId).color;

    double value = model.value;
    return PieChartSectionData(
      color: colour,
      value: value,
      title: "",
      radius: radius,
      titleStyle: context.textTheme.bodyLarge!
          .copyWith(fontSize: fontSize, fontWeight: FontWeight.bold),
    );
  }

  List<Widget> _informations(List<ChartBudgetModel> list) {
    return list.map((e) {
      Color colour = IconManagerData.getIconModel(e.iconId).color;
      return Indicator(
        color: colour,
        text: '${e.budgetName} (${e.value.toStringAsFixed(2)}%)',
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
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
