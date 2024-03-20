import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/models_widget/icon_model.dart';
import 'package:flutter/material.dart';

class ExpenseCategory extends StatefulWidget {
  const ExpenseCategory(
      {Key? key,
      required this.list,
      this.initialValue,
      required this.onChanged})
      : super(key: key);
  final List<BudgetModel> list;
  final BudgetModel? initialValue;
  final void Function(String budgetId) onChanged;

  @override
  State<ExpenseCategory> createState() => _ExpenseCategoryState();
}

class _ExpenseCategoryState extends State<ExpenseCategory> {
  late BudgetModel? _selectedItem;

  @override
  void initState() {
    _selectedItem = widget.initialValue;
    if (_selectedItem != null) {
      widget.onChanged(_selectedItem!.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: widget.list.map((e) => _itemCategory(e)).toList(),
    );
  }

  Widget _itemCategory(BudgetModel model) {
    bool isSelected =
        _selectedItem != null && model.icon.id == _selectedItem!.icon.id;
    return isSelected
        ? _itemCategoryBase(model,
            backgroundColor: ColorManager.purple22,
            textColor: ColorManager.white)
        : InkWell(
            onTap: () {
              setState(() {
                _selectedItem = model;
              });
              widget.onChanged(_selectedItem!.id);
            },
            child: _itemCategoryBase(model,
                backgroundColor: ColorManager.white,
                textColor: ColorManager.black),
          );
  }

  Widget _itemCategoryBase(BudgetModel model,
      {required Color backgroundColor, required Color textColor}) {
    IconModel icon = model.icon;
    return Ink(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: MediaQuery.of(context).size.width / 3 - 24,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: ColorManager.grey3),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          Icon(
            icon.iconData,
            color: icon.color,
          ),
          gapH16,
          BText(model.name, fontWeight: FontWeight.bold, color: textColor)
        ],
      ),
    );
  }
}
