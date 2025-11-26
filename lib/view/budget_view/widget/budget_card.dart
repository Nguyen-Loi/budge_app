import 'dart:math';

import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_money.dart';
import 'package:budget_app/common/widget/custom/budget_expense_status.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BudgetCard extends StatefulWidget {
  const BudgetCard({super.key, required this.model, this.isPreview = false});
  final BudgetModel model;
  final bool isPreview;

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for tap interaction
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Initialize scale animation
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          Navigator.pushNamed(context, RoutePath.budgetDetail,
              arguments: widget.model.id);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.surface.withAlpha(150),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopRow(context),
                      gapH12,
                      _buildBottomRow(context),
                    ],
                  ),
                ),
              ),
            ),
            _tagItem(context)
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      children: [
        // Icon and name section
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withAlpha(30),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: BIcon(name: widget.model.iconName, size: 20),
        ),
        gapW12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BText(
                widget.model.name,
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              gapH4,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: widget.model.budgetType == BudgetTypeEnum.income
                      ? Theme.of(context).colorScheme.tertiary.withAlpha(100)
                      : Theme.of(context).colorScheme.error.withAlpha(100),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: BText.caption(
                  widget.model.budgetType.content(context),
                  color: widget.model.budgetType == BudgetTypeEnum.income
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        gapW8,
        // Amount section
        Consumer(builder: (_, ref, __) {
          return _buildAmountDisplay(context, ref: ref);
        }),
        if (!widget.isPreview) ...[
          gapW8,
          Icon(
            IconManager.arrowNext,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            size: 18,
          ),
        ]
      ],
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    String dateText = widget.model.rangeDateTimeType ==
            RangeDateTimeEnum.allTime
        ? context.loc.allTime
        : '${widget.model.startDate.toFormatDate()} - ${widget.model.endDate.toFormatDate()}';

    return Row(
      children: [
        // Date info
        Expanded(
          child: Row(
            children: [
              Icon(
                widget.model.rangeDateTimeType == RangeDateTimeEnum.allTime
                    ? IconManager.emojiSmile
                    : IconManager.calendar,
                size: 14,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
              ),
              gapW8,
              Expanded(
                child: BText.caption(
                  dateText,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Progress section (only if not all-time)
        if (widget.model.rangeDateTimeType != RangeDateTimeEnum.allTime) ...[
          gapW16,
          _buildCompactProgress(context),
        ],
      ],
    );
  }

  Widget _buildAmountDisplay(BuildContext context, {required WidgetRef ref}) {
    bool isAllTime =
        widget.model.rangeDateTimeType == RangeDateTimeEnum.allTime;

    if (widget.model.budgetType == BudgetTypeEnum.income) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          BText.b1(
            widget.model.currentAmount.toMoneyStr(ref, isPrefix: true),
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w700,
          ),
          BText.caption(
            context.loc.currentValue,
            color: Theme.of(context).colorScheme.tertiary.withAlpha(150),
          ),
        ],
      );
    } else {
      // Expense
      double spentPercent = widget.model.budgetLimit > 0
          ? min(
              widget.model.currentAmount.abs() * 100 / widget.model.budgetLimit,
              100)
          : 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isAllTime) ...[
            // For all-time budgets, show only current amount without limit
            BTextMoney(
              widget.model.currentAmount.toInt(),
              fontSize: 18,
            ),
            BText.caption(
              context.loc.currentValue,
              color:
                  _getExpenseStatusColor(context, spentPercent).withAlpha(150),
            ),
          ] else ...[
            // For time-limited budgets, show current/limit format
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: widget.model.currentAmount.abs().toMoneyStr(ref),
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _getExpenseStatusColor(context, spentPercent),
                    ),
                  ),
                  TextSpan(
                    text: '/${widget.model.budgetLimit.toMoneyStr(ref)}',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: _getExpenseStatusColor(context, spentPercent),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BText.caption(
                    '${spentPercent.toInt()}%',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  gapW4,
                  Icon(
                    _getExpenseStatusIcon(spentPercent),
                    color: Colors.white,
                    size: 10,
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }
  }

  Widget _buildCompactProgress(BuildContext context) {
    if (widget.model.budgetType == BudgetTypeEnum.income) {
      // For income budgets, always show progress bar for non-allTime budgets
      double progressPercent = 0;

      if (widget.model.budgetLimit > 0) {
        // If there's a limit, calculate actual progress
        progressPercent =
            (widget.model.currentAmount.abs() / widget.model.budgetLimit * 100)
                .clamp(0, 100);
      } else {
        // If no limit is set, show a visual indicator based on current amount
        progressPercent = widget.model.currentAmount > 0
            ? 30
            : 0; // Show some progress if there's income
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Theme.of(context).colorScheme.surface.withAlpha(150),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progressPercent / 100,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getIncomeProgressColor(context, progressPercent),
                ),
              ),
            ),
          ),
          gapW8,
          BText.caption(
            widget.model.budgetLimit > 0
                ? '${progressPercent.toStringAsFixed(0)}%'
                : '●', // Show a dot indicator when no limit is set
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w600,
          ),
        ],
      );
    } else {
      return SizedBox(
        width: 80,
        height: 4,
        child: BudgetExpenseStatus(budget: widget.model),
      );
    }
  }

  Widget _tagItem(BuildContext context) {
    if (widget.model.budgetStatusTime == BudgetStatusTime.active) {
      return const SizedBox.shrink();
    }
    return Positioned(
        right: -8,
        top: -8,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.model.budgetStatusTime.color(context),
              boxShadow: [
                BoxShadow(
                  color: widget.model.budgetStatusTime
                      .color(context)
                      .withAlpha(50),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  widget.model.budgetStatusTime.svgAsset(context),
                  width: 14,
                  height: 14,
                ),
                gapW8,
                BText.caption(widget.model.budgetStatusTime.contentLoc(context),
                    color: ColorManager.white, fontWeight: FontWeight.w700),
              ],
            )));
  }

  Color _getExpenseStatusColor(BuildContext context, double spentPercent) {
    if (spentPercent <= 25) {
      return const Color(0xFF29B6F6); // Light blue
    } else if (spentPercent <= 50) {
      return const Color(0xFF4CAF50); // Green
    } else if (spentPercent < 100) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFE53935); // Red
    }
  }

  IconData _getExpenseStatusIcon(double spentPercent) {
    if (spentPercent <= 25) {
      return IconManager.emojiSmile;
    } else if (spentPercent <= 50) {
      return IconManager.emojiSmile;
    } else if (spentPercent < 100) {
      return IconManager.emojiSurprise;
    } else {
      return IconManager.emojiFrown;
    }
  }

  Color _getIncomeProgressColor(BuildContext context, double progressPercent) {
    if (progressPercent <= 25) {
      return const Color(0xFFE3F2FD); // Very light blue
    } else if (progressPercent <= 50) {
      return const Color(0xFF2196F3); // Blue
    } else if (progressPercent <= 75) {
      return const Color(0xFF1976D2); // Darker blue
    } else {
      return Theme.of(context).colorScheme.tertiary; // Success green
    }
  }
}
