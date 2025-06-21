import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/data/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

class BudgetTransactionCard extends StatefulWidget {
  final BudgetTransactionsModel budgetTransaction;

  const BudgetTransactionCard({
    super.key,
    required this.budgetTransaction,
  });

  @override
  State<BudgetTransactionCard> createState() => _BudgetTransactionCardState();
}

class _BudgetTransactionCardState extends State<BudgetTransactionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final budget = widget.budgetTransaction.budget;
    final transactions = widget.budgetTransaction.transactions;
    final totalAmount = transactions.fold<int>(0, (sum, t) => sum + t.amount);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Budget Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: IconManagerData.getIconModel(budget.iconName)
                          .color
                          .withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BIcon(
                      name: budget.iconName,
                      size: 24,
                    ),
                  ),
                  gapW12,
                  // Budget Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BText.b1(
                          budget.name,
                          fontWeight: FontWeight.w600,
                        ),
                        gapH4,
                        BText.b3(
                          '${transactions.length} ${context.loc.transaction}',
                        ),
                      ],
                    ),
                  ),
                  // Total Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      gapH4,
                      BText(
                        totalAmount.toMoneyStrContext(context),
                        fontWeight: FontWeight.bold,
                        color: totalAmount >= 0
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.error,
                      ),
                      gapH4,
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Expandable Transactions List
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withAlpha(100),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ColumnWithSpacing(
                  spacing: 8,
                  children: transactions.map((transaction) {
                    return _buildTransactionItem(context, transaction);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      BuildContext context, TransactionModel transaction) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withAlpha(50),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Transaction Date
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(50),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: BText.caption(
                  transaction.transactionDate.toString().split(' ')[0],
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              gapW8,
              // Transaction Note
              // Transaction Amount
              BText(
                transaction.amount.toMoneyStrContext(context),
                fontWeight: FontWeight.w600,
                color: transaction.amount >= 0
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.error,
              ),
            ],
          ),
          if (transaction.note.isNotEmpty) ...[
            gapH8,
            // Transaction Note
            BText.b3(
              transaction.note,
            ),
          ],
        ],
      ),
    );
  }
}
