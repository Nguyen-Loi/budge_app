import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_list_async.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_card.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_list/controller/budget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBudgetList extends ConsumerWidget {
  const HomeBudgetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logSuccess('rebuild list');
    bool isLoading = ref.watch(budgetControllerProvider);
    return BListAsync(
        data: ref.watch(fetchBudgetsProvider),
        itemBuilder: (_, __) => isLoading
            ? const BStatus.loading()
            : ColumnWithSpacing(
                children: ref
                    .watch(budgetsProvider)
                    .map((e) => HomeBudgetCard(model: e))
                    .toList(),
              ));
  }
}
