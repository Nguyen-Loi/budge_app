import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_view/widget/budget_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetPage extends ConsumerStatefulWidget {
  const BudgetPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BudgetPageState();
}

class _BudgetPageState extends ConsumerState<BudgetPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseView(
      title: context.loc.budgetInUse,
      floatingActionButton: FloatingActionButton(
        heroTag: RoutePath.newBudget,
        onPressed: () {
          Navigator.pushNamed(context, RoutePath.newBudget);
        },
        child: Icon(IconManager.add, color: ColorManager.white),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _budgetList(),
        ],
      ),
    );
  }

  Widget _budgetList() {
    List<BudgetModel> list = ref.watch(budgetBaseControllerProvider);
    return list.isEmpty
        ? BStatus.empty(
            text: context.loc.budgetEmpty,
          )
        : ColumnWithSpacing(
            children: list.map((e) => BudgetCard(model: e)).toList(),
          );
  }
}
