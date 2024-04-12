import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_avatar.dart';
import 'package:budget_app/common/widget/b_dropdown.dart';
import 'package:budget_app/common/widget/b_search_bar.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_appbar.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_card_balance.dart';
import 'package:budget_app/view/new_expense_view/new_expense_view.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_list/home_budget_list.dart';
import 'package:budget_app/view/home_page/widgets/home_item_come.dart';
import 'package:budget_app/view/income_view/income_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TextEditingController _searchController = TextEditingController();
  List<String> get listCategory => ['A', 'B', 'C', 'D'];
  @override
  Widget build(BuildContext context) {
    logError('rebuild full');
    return Scaffold(
      appBar: AppBar(
        actions: [
          gapW16,
          const SizedBox.shrink(),
          const Expanded(
            child: HomeBudgetAppBar(),
          ),
          gapW16,
          GestureDetector(
              onTap: () {}, child: Icon(IconConstants.notification)),
          gapW16,
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          const HomeBudgetCardBalance(),
          gapH16,
          _inComeAndExpense(context),
          gapH16,
          _searchAndCategory(),
          gapH16,
          const HomeBudgetList()
        ],
      ),
    );
  }

  Widget _inComeAndExpense(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HomeItemCome(
              title: 'Income',
              money: 4250,
              color: ColorManager.purple11,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const IncomeView()));
              }),
        ),
        gapW16,
        Expanded(
          child: HomeItemCome(
              title: 'Expense',
              money: 4250,
              color: ColorManager.purple21,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const NewExpenseView()));
              }),
        )
      ],
    );
  }

  Widget _searchAndCategory() {
    return Row(
      children: [
        Expanded(
          child: BSearchBar(
            controller: _searchController,
            hintText: 'Search ...',
          ),
        ),
        gapW16,
        BDropdown<String>(
            value: listCategory.isNotEmpty ? listCategory.first : null,
            label: (v) => v.toString(),
            items: listCategory,
            onChanged: (v) => {})
      ],
    );
  }
}
