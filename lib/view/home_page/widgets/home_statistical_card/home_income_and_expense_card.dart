import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/models/statistical_model.dart';
import 'package:budget_app/view/home_page/widgets/home_statistical_card/controller/statistical_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeIncomeAndExpenseCard extends ConsumerWidget {
  const HomeIncomeAndExpenseCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statisticalControllerProvider);
    final isLoading = ref.watch(statisticalFetchProvider).isLoading;
    return isLoading ? _loading() : _hasData(context, state!);
  }

  Widget _hasData(BuildContext context, StatisticalModel model) {
    return Row(
      children: [
        Expanded(
          child: _HomeStaisticalCardBase(
              title: 'Income',
              money: model.income,
              color: ColorManager.purple11,
              onTap: () {
                Navigator.pushNamed(context, RoutePath.income);
              }),
        ),
        gapW16,
        Expanded(
          child: _HomeStaisticalCardBase(
              title: 'Expense',
              money: model.expense,
              color: ColorManager.purple21,
              onTap: () {
                Navigator.pushNamed(context, RoutePath.expense);
              }),
        )
      ],
    );
  }

  Widget _loading() {
    return Row(
      children: [
        Expanded(
          child: _HomeStaisticalCardBase(
              title: 'Income',
              money: 0,
              color: ColorManager.purple11,
              onTap: () {}),
        ),
        gapW16,
        Expanded(
          child: _HomeStaisticalCardBase(
              title: 'Expense',
              money: 0,
              color: ColorManager.purple21,
              onTap: () {}),
        )
      ],
    );
  }
}

class _HomeStaisticalCardBase extends StatelessWidget {
  final String title;
  final int money;
  final Color color;
  final VoidCallback onTap;

  const _HomeStaisticalCardBase(
      {required this.title,
      required this.money,
      required this.color,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                BText(title, color: ColorManager.white),
                gapH16,
                BText.h2(money.toMoneyStr(), color: ColorManager.white),
              ],
            ),
            gapW24,
            CircleAvatar(
              radius: 20,
              backgroundColor: ColorManager.white,
              child: IconButton(
                onPressed: onTap,
                color: ColorManager.white,
                icon: Icon(
                  IconConstants.add,
                  color: ColorManager.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
