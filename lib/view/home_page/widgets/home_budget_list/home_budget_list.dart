import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_card.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_list/controller/budget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBudgetList extends ConsumerWidget {
  const HomeBudgetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<BudgetModel> list = ref.watch(budgetControllerProvider);
    return ref.watch(budgetsFetchProvider).when(
        data: (_) {
          return list.isEmpty
              ? const BStatus.empty(
                  text: 'You don\'t have any budget yet.',
                )
              : ColumnWithSpacing(
                  children: list
                      .map((e) => HomeBudgetCard(model: e))
                      .toList(),
                );
        },
        error: (_, __) => const BStatus.error(),
        loading: () => const BStatus.loading());
  }
}
