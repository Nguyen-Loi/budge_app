import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/color_constants.dart';
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
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                BText(title, color: ColorConstants.white),
                gapH16,
                BText.h2(money.toString(), color: ColorConstants.white),
              ],
            ),
            gapW24,
            CircleAvatar(
              radius: 20,
              backgroundColor: ColorConstants.white,
              child: IconButton(
                onPressed: onTap,
                color: ColorConstants.white,
                icon: Icon(
                  IconConstants.add,
                  color: ColorConstants.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
