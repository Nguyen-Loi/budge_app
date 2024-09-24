import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
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
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        length: BudgetTypeEnum.values.length,
        vsync: this,
        initialIndex: BudgetTypeEnum.income.index);
    super.initState();
  }

  List<Widget> _tabs(BuildContext context) => BudgetTypeEnum.values.map((e) {
        return Tab(
          text: e.content(context),
        );
      }).toList();

  List<Widget> _tabBarViews(BuildContext context,
          {required List<BudgetModel> list}) =>
      BudgetTypeEnum.values.map((type) {
        final l = list.where((e) => e.budgetType == type).toList();
        return _itemView(list: l);
      }).toList();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final list = ref.watch(budgetBaseControllerProvider);
    return BaseView(
      title: context.loc.budgetInUse,
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: () {
          Navigator.pushNamed(context, RoutePath.newBudget);
        },
        child: Icon(IconManager.add, color: ColorManager.white),
      ),
      bottom: TabBar(
        controller: _tabController,
        tabs: _tabs(context),
      
      ),
      child: TabBarView(
        controller: _tabController,
        children: _tabBarViews(context, list: list),
      ),
    );
  }

  Widget _itemView({required List<BudgetModel> list}) {
    return list.isEmpty
        ? Center(
            child: BStatus.empty(
              text: context.loc.budgetEmpty,
            ),
          )
        : ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              ColumnWithSpacing(
                children: list.map((e) => BudgetCard(model: e)).toList(),
              )
            ],
          );
  }
}
