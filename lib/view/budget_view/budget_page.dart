import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button_icon.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/size_constants.dart';
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
      expandedHeight: 180,
      floating: true,
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: ColorManager.primaryBlue,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BText.appbar(
                context.loc.budgetInUse,
              ),
              const SizedBox(height: 8),
              BText(
                context.loc.budgetPageDesc,
                color: Theme.of(context).colorScheme.onPrimary.withAlpha(200),
              ),
              const Spacer(),
              _buildAddBudgetButton(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddBudgetButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: BButtonIcon(
        iconData: IconManager.add,
        title: context.loc.newBudget,
        onPressed: () {
          Navigator.pushNamed(context, RoutePath.newBudget);
        },
      ),
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
    bool sizeSmall = SizeConstants.isSmallScreen(context);
    final screenWidth = MediaQuery.of(context).size.width;

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
        : sizeSmall
            ? ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                children: [
                  ColumnWithSpacing(
                    spacing: 16,
                    children: list.map((e) => BudgetCard(model: e)).toList(),
                  ),
                ],
              )
            : GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > SizeConstants.gridSize ? 3 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 5 / 2,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return BudgetCard(model: list[index]);
                },
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
