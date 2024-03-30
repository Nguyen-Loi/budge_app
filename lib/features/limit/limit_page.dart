import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/field_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/features/limit/new_limit/new_limit_view.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:flutter/material.dart';

class LimitPage extends StatelessWidget {
  LimitPage({Key? key}) : super(key: key);
  final List<BudgetModel> listBudget = [
    BudgetModel({
      FieldConstants.name: 'Data 1',
      FieldConstants.iconId: 0,
      FieldConstants.limit: 200
    }),
    BudgetModel({
      FieldConstants.name: 'Data 2',
      FieldConstants.iconId: 1,
      FieldConstants.limit: 300
    }),
    BudgetModel({
      FieldConstants.name: 'Data 3',
      FieldConstants.iconId: 2,
      FieldConstants.limit: 400
    }),
    BudgetModel({
      FieldConstants.name: 'Data 4',
      FieldConstants.iconId: 3,
      FieldConstants.limit: 500
    }),
    BudgetModel({
      FieldConstants.name: 'Data 5',
      FieldConstants.iconId: 4,
      FieldConstants.limit: 600
    }),
    BudgetModel({
      FieldConstants.name: 'Data 6',
      FieldConstants.iconId: 5,
      FieldConstants.limit: 700
    }),
    BudgetModel({
      FieldConstants.name: 'Data 7',
      FieldConstants.iconId: 6,
      FieldConstants.limit: 800
    }),
    BudgetModel({
      FieldConstants.name: 'Data 8',
      FieldConstants.iconId: 7,
      FieldConstants.limit: 900
    }),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorManager.purple12,
      child: Column(
        children: [
          const SizedBox(height: 100),
          Expanded(
            child: _body(context),
          )
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const BText.h2(
              'All limits',
            ),
            gapH16,
            _listBudget(context)
          ],
        ));
  }

  Widget _listBudget(BuildContext context) {
    return ColumnWithSpacing(children: [
      ...listBudget.map((e) => _budgetItem(e)).toList(),
      gapH24,
      _buttonAddCategory(context),
    ]);
  }

  Widget _budgetItem(BudgetModel model) {
    const double iconSize = 18;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BIcon(id: model.iconId),
            gapW16,
            BText(model.name.toString()),
            gapW16,
            Expanded(
              child: RowWithSpacing(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 4,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        IconConstants.minus,
                        size: iconSize,
                      )),
                  BText(model.limit.toMoneyStr()),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        IconConstants.add,
                        size: iconSize,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonAddCategory(BuildContext context) {
    return BButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const NewLimitView(),
            ),
          );
        },
        title: 'Add new category');
  }
}
