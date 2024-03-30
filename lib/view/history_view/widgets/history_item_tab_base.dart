import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:flutter/material.dart';

abstract class HistoryItemTabBase<T> extends StatelessWidget {
  const HistoryItemTabBase({super.key});
  List<T> get list;
  Widget card(T model);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        child: ListViewWithSpacing(
          children: list
              .map((e) => Card(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: card(e)),
                  ))
              .toList(),
        ));
  }
}
