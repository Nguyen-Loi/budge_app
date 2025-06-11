import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_money.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/icon_manager_data.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatefulWidget {
  const TransactionCard({super.key, required this.model});
  final TransactionCardModel model;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = IconManagerData.getIconModel(widget.model.iconId).color;
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                _showInfo(context);
              },
              onTapDown: (_) => _animationController.forward(),
              onTapUp: (_) => _animationController.reverse(),
              onTapCancel: () => _animationController.reverse(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Hero(
                    tag: 'transaction_icon_${widget.model.transaction.id}',
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: iconColor.withAlpha(50),
                      child: BIcon(id: widget.model.iconId),
                    ),
                  ),
                  title: BText(widget.model.transactionName,
                      fontWeight: FontWeight.bold),
                  subtitle: BText.b3(
                      widget.model.transaction.transactionDate.toFormatDate()),
                  trailing: BTextMoney(widget.model.transaction.amount),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showInfo(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _TransactionDetailDialog(model: widget.model);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}

class _TransactionDetailDialog extends StatefulWidget {
  const _TransactionDetailDialog({required this.model});
  final TransactionCardModel model;

  @override
  State<_TransactionDetailDialog> createState() =>
      _TransactionDetailDialogState();
}

class _TransactionDetailDialogState extends State<_TransactionDetailDialog>
    with TickerProviderStateMixin {
  late AnimationController _contentController;
  late Animation<double> _contentAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _contentAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _contentController.forward();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = IconManagerData.getIconModel(widget.model.iconId).color;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient background
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        iconColor.withOpacity(0.8),
                        iconColor.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Hero(
                        tag: 'transaction_icon_${widget.model.transaction.id}',
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: BIcon(id: widget.model.iconId, size: 40),
                        ),
                      ),
                      gapH16,
                      BText.b1(
                        widget.model.transactionName,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Content area
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _contentAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: ColumnWithSpacing(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 16,
                        children: [
                          _buildDetailCard(
                            icon: Icons.note_outlined,
                            label: context.loc.note,
                            content: widget.model.transaction.note.isEmpty
                                ? context.loc.noData
                                : widget.model.transaction.note,
                            isNote: true,
                          ),
                          _buildAmountCard(context),
                          _buildDetailCard(
                            icon: Icons.calendar_today_outlined,
                            label: context.loc.transactionDate,
                            content: widget.model.transaction.transactionDate
                                .toFormatDate(),
                          ),
                          _buildDetailCard(
                            icon: Icons.schedule_outlined,
                            label: context.loc.createdDate,
                            content: widget.model.transaction.createdDate
                                .toFormatDate(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Action button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                      label: BText(
                        context.loc.close,
                        color: ColorManager.white,
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String content,
    bool isNote = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            isNote ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BText.b3(
                  label,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                gapH4,
                BText(
                  content,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(BuildContext context) {
    Color color;
    IconData icon;
    switch (widget.model.transaction.transactionType) {
      case TransactionTypeEnum.income:
        color = Theme.of(context).colorScheme.tertiary;
        icon = Icons.trending_up;
        break;
      case TransactionTypeEnum.expense:
        color = Theme.of(context).colorScheme.error;
        icon = Icons.trending_down;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BText.b3(
                  context.loc.amount,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                gapH4,
                BText.b1(
                  widget.model.transaction.amount.toMoneyStrTruncated(),
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
