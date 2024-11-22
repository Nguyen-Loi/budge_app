import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/controller/budget_detail_controller.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/widget/budget_transacitons_detail_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

abstract class BudgetBaseDetailView extends StatelessWidget {
  const BudgetBaseDetailView({
    super.key,
    required this.budget,
    required this.transactions,
  });

  final BudgetModel budget;
  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: budget.name,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RoutePath.budgetModify,
                  arguments: budget);
            },
            icon: Icon(IconManager.modify, size: 16))
      ],
      child: _body(context),
    );
  }

  List<Widget> header(BuildContext context, BudgetModel budget);

  Widget itemStatus(BuildContext context) {
    final status = budget.budgetStatusTime;
    return itemRow(context,
        svgAsset: SvgAssets.status,
        label: context.loc.status,
        value: status.contentLoc(context),
        colorValue: status.color(context),
        isBold: true);
  }

  Widget itemReview(BuildContext context) {
    return itemRow(context,
        svgAsset: SvgAssets.review,
        label: context.loc.review,
        value: budget.getReview(context, transactions: transactions),
        isBold: false);
  }

  Widget itemOperatingTime(BuildContext context) {
    final value =
        "${budget.startDate.toFormatDate(strFormat: 'dd/MM/yyyy')} - ${budget.endDate.toFormatDate(strFormat: 'dd/MM/yyyy')}";
    return itemRow(context,
        svgAsset: SvgAssets.operatingTime,
        label: context.loc.operatingTime,
        value: value);
  }

  Widget itemRow(BuildContext context,
      {required String svgAsset,
      required String label,
      required String value,
      Color? colorValue,
      bool isBold = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyMedium!.color!,
                  BlendMode.srcIn),
            ),
            gapW8,
            BText(label),
          ],
        ),
        gapW24,
        Expanded(
          child: BText(
            value,
            color: colorValue,
            fontWeight: isBold ? FontWeight.w700 : null,
            textAlign: TextAlign.end,
            maxLines: null,
          ),
        )
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: ListView(
        children: [
          _status(context),
          gapH24,
          BudgetDetailTransactions(transactions),
        ],
      ),
    );
  }

  Widget _status(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      BudgetModel model = ref.watch(budgetDetailControllerProvider(budget));
      return ColumnWithSpacing(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: header(context, model));
    });
  }
}
