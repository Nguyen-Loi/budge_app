import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/chart_budget.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/view/home_page/widgets/home_chart/controller/home_chart_controller.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BText('Tháng này'.hardcoded),
            TextButton(
              child: BText(
                'Xem tất cả'.hardcoded,
                color: ColorManager.blue,
                fontWeight: FontWeight.bold,
              ),
              onPressed: () {
                Navigator.pushNamed(context, RoutePath.report);
              },
            ),
          ],
        ),
        ChartBudget(list: list),
      ],
    );
  }
}
