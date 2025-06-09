import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
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
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutePath.budgetModify,
                    arguments: budget);
              },
              icon: Icon(IconManager.modify, size: 18)),
        )
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(80),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withAlpha(120),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  svgAsset,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
              ),
              gapW12,
              BText(
                label,
              ),
            ],
          ),
          gapW16,
          Expanded(
            child: BText.b3(
              value,
              color: colorValue ?? Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withAlpha(40),
          ],
        ),
      ),
      child: ListView(
        children: [
          _statusCard(context),
          gapH24,
          _transactionsCard(context),
        ],
      ),
    );
  }

  Widget _statusCard(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).shadowColor.withAlpha(30),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withAlpha(30),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _status(context),
        ),
      ),
    );
  }

  Widget _transactionsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).shadowColor.withAlpha(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  gapW12,
                  BText(
                    context.loc.transactions,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              gapH16,
              BudgetDetailTransactions(transactions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _status(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      BudgetModel model = ref.watch(budgetDetailControllerProvider(budget));
      return ColumnWithSpacing(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: header(context, model));
    });
  }
}
