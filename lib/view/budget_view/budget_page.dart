import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button_icon.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/budget_view/widget/budget_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetPage extends ConsumerStatefulWidget {
  const BudgetPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BudgetPageState();
}

class _BudgetPageState extends ConsumerState<BudgetPage>
    with SingleTickerProviderStateMixin {
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
        final l = list.where((e) => e.budgetType == type).toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));
        return _itemView(list: l);
      }).toList();

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(budgetBaseControllerProvider);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverHeader(),
          _buildTabBarSliver(),
        ],
        body: TabBarView(
          controller: _tabController,
          children: _tabBarViews(context, list: list),
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 140,
      floating: true,
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: ColorManager.primaryBlue,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BText.appbar(
                      context.loc.budgetInUse,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: BText(
                        context.loc.budgetPageDesc,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withAlpha(200),
                      ),
                    )
                  ],
                ),
              ),
              _buildAddBudgetButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddBudgetButton() {
    return BButtonIcon(
      iconData: IconManager.add,
      title: context.loc.newBudget,
      onPressed: () {
        Navigator.pushNamed(context, RoutePath.newBudget);
      },
    );
  }

  Widget _buildTabBarSliver() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabBarDelegate(
        TabBar(
          controller: _tabController,
          tabs: _tabs(context),
          indicatorColor: ColorManager.primaryBlue,
          indicatorWeight: 3,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
          labelColor: ColorManager.primaryBlue,
          unselectedLabelColor: ColorManager.greyLight,
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _itemView({required List<BudgetModel> list}) {
    return list.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BStatus.empty(
                    text: context.loc.budgetEmpty,
                  ),
                  gapH40,
                ],
              ),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: list.map((e) {
                      return ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: 400, minWidth: 350),
                        child: BudgetCard(model: e),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 40), 
              ],
            ),
          );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(50),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
