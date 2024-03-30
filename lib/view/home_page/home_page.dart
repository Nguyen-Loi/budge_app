import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_avatar.dart';
import 'package:budget_app/common/widget/b_dropdown.dart';
import 'package:budget_app/common/widget/b_search_bar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/view/expense_view/expense_view.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:budget_app/view/home_page/widgets/home_budge_card.dart';
import 'package:budget_app/view/home_page/widgets/home_item_come.dart';
import 'package:budget_app/view/income_view/income_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TextEditingController _searchController = TextEditingController();
  final HomeController _controller = HomeController();
  List<String> get listCategory => ['A', 'B', 'C', 'D'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          gapW16,
          const SizedBox.shrink(),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BTextRichSpace(text1: 'Hello ', text2: 'Roya!'),
                gapH8,
                BText.caption('Your finances are looking good'),
              ],
            ),
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
          _cardBalance(),
          gapH16,
          _inComeAndExpense(context),
          gapH16,
          _searchAndCategory(),
          gapH16,
          _listBudget()
        ],
      ),
    );
  }

  Widget _cardBalance() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: ColorManager.primary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const BAvatar.network(
                'https://acpro.edu.vn/hinh-nhung-chu-meo-de-thuong/imager_173.jpg'),
            gapH24,
            BText('Your available lalance is', color: ColorManager.white),
            gapH16,
            BText.h1('\$ 2028', color: ColorManager.white),
          ],
        ),
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => IncomeView()));
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
                    MaterialPageRoute(builder: (_) => const ExpenseView()));
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

  Widget _listBudget() {
    return ColumnWithSpacing(
      children: _controller.listBuget
          .map(
            (e) => HomeBudgeCard(model: e),
          )
          .toList(),
    );
  }
}
