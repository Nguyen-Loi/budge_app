import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:flutter/material.dart';

class HomeItemCome extends StatelessWidget {
  final String title;
  final int money;
  final Color color;
  final VoidCallback onTap;

  const HomeItemCome(
      {super.key,
      required this.title,
      required this.money,
      required this.color,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Column(
            children: [
              BText(title),
              gapH16,
              BText.h2(money.toString()),
            ],
          ),
          gapW24,
          IconButton(
            onPressed: onTap,
            icon: Icon(IconConstants.add),
          )
        ],
      ),
    );
  }
}
