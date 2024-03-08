import 'package:budget_app/common/widget/b_dropdown.dart';
import 'package:budget_app/common/widget/b_search_bar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/common/widget/form/b_image.dart';
import 'package:budget_app/common/widget/form/with_spacing.dart';
import 'package:budget_app/constants/color_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/features/home/widgets/home_budge_card.dart';
import 'package:budget_app/features/home/widgets/home_item_come.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final TextEditingController _controller = TextEditingController();
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
          Icon(IconConstants.notification),
          gapW16,
        ],
      ),
      body: ListView(
        children: [
          _cardBalance(),
          gapH16,
          _inComeAndExpense(),
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
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          const BImage.avatar(
              'https://acpro.edu.vn/hinh-nhung-chu-meo-de-thuong/imager_173.jpg'),
          gapH24,
          const BText('Your available lalance is'),
          gapH16,
          BText('\$ 2028', color: ColorConstants.white),
        ],
      ),
    );
  }

  Widget _inComeAndExpense() {
    return Row(
      children: [
        HomeItemCome(
            title: 'Income',
            money: 4250,
            color: ColorConstants.purple11,
            onTap: () {}),
        gapW16,
        HomeItemCome(
            title: 'Income',
            money: 4250,
            color: ColorConstants.purple21,
            onTap: () {})
      ],
    );
  }

  Widget _searchAndCategory() {
    return Row(
      children: [
        Expanded(
          child: BSearchBar(controller: _controller),
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
      children: const [
        HomeBudgeCard(),
        HomeBudgeCard(),
        HomeBudgeCard(),
        HomeBudgeCard(),
        HomeBudgeCard(),
        HomeBudgeCard(),
      ],
    );
  }
}
