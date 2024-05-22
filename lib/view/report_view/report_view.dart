import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/chart_budget.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Báo cáo'.hardcoded,
      child: ListView(
        children: [
          ChartBudget(list: list),
        ],
      ),
    );
  }
  
  Widget _cardBudget(List<>){
    return 
  }
}