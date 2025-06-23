import 'package:budget_app/common/widget/b_filter_chip.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/models_widget/icon_model.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/report_page/controller/report_page_controller.dart';
import 'package:flutter/material.dart';

class ReportFilterDialog extends StatefulWidget {
  final ReportFilterState currentState;
  final List<BudgetModel> availableBudgets;
  final List<TransactionTypeEnum> availableTransactionTypes;
  final List<DateTimeRange> dateRangeOptions;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTimeRange?, List<TransactionTypeEnum>?, List<String>?)
      onFiltersChanged;
  final Function(List<TransactionTypeEnum>) getRelevantBudgets;

  const ReportFilterDialog({
    super.key,
    required this.currentState,
    required this.availableBudgets,
    required this.availableTransactionTypes,
    required this.dateRangeOptions,
    this.firstDate,
    this.lastDate,
    required this.onFiltersChanged,
    required this.getRelevantBudgets,
  });

  @override
  State<ReportFilterDialog> createState() => _ReportFilterDialogState();
}

class _ReportFilterDialogState extends State<ReportFilterDialog> {
  late DateTimeRange _selectedDateRange;
  late List<TransactionTypeEnum> _selectedTransactionTypes;
  late List<String> _selectedBudgetIds;

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.currentState.dateTimeRange;
    _selectedTransactionTypes = List.from(widget.currentState.transactionTypes);
    _selectedBudgetIds = List.from(widget.currentState.selectedBudgetIds);
  }

  List<BudgetModel> get _availableBudgetsForSelectedTypes {
    return widget.getRelevantBudgets(_selectedTransactionTypes);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: BText.h3(
        context.loc.filter,
        fontWeight: FontWeight.bold,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateRangeSection(),
              gapH24,
              _buildTransactionTypesSection(),
              gapH24,
              _buildBudgetsSection(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: BText(context.loc.cancel),
        ),
        FilledButton(
          onPressed: () {
            widget.onFiltersChanged(
              _selectedDateRange,
              _selectedTransactionTypes,
              _selectedBudgetIds,
            );
            Navigator.of(context).pop();
          },
          child: BText(
            context.loc.confirm,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(
          context.loc.dateRange,
          fontWeight: FontWeight.bold,
        ),
        gapH8,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: _showDateRangePicker,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BText(
                  '${_selectedDateRange.start.toFormatDate()} - ${_selectedDateRange.end.toFormatDate()}',
                ),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(
          context.loc.type,
          fontWeight: FontWeight.bold,
        ),
        gapH8,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.availableTransactionTypes.map((type) {
            final isSelected = _selectedTransactionTypes.contains(type);
            return BFilterChip(
              label: type.content(context),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTransactionTypes.add(type);
                  } else {
                    _selectedTransactionTypes.remove(type);
                  }

                  // Update selected budgets to only include relevant ones
                  final relevantBudgets = _availableBudgetsForSelectedTypes;
                  final relevantBudgetIds =
                      relevantBudgets.map((b) => b.id).toSet();
                  _selectedBudgetIds = _selectedBudgetIds
                      .where((id) => relevantBudgetIds.contains(id))
                      .toList();
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBudgetsSection() {
    final availableBudgets = _availableBudgetsForSelectedTypes;
    final hasSelectedBudgets =
        _selectedBudgetIds.length == availableBudgets.length;

    if (availableBudgets.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BText(
            context.loc.budgets,
            fontWeight: FontWeight.bold,
          ),
          gapH8,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withAlpha(100),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                gapW8,
                Expanded(
                  child: BText.b3(
                    context.loc.noBudgetsSelectedTransaction,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BText(
              context.loc.budgets,
              fontWeight: FontWeight.bold,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_selectedBudgetIds.length == availableBudgets.length) {
                    _selectedBudgetIds.clear();
                  } else {
                    _selectedBudgetIds =
                        availableBudgets.map((b) => b.id).toList();
                  }
                });
              },
              child: BText.b3(
                hasSelectedBudgets
                    ? context.loc.removeAll
                    : context.loc.selectAll,
                color: hasSelectedBudgets
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        gapH8,
        if (_selectedTransactionTypes.isNotEmpty) ...[
          // Show transaction type indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(50),
              borderRadius: BorderRadius.circular(6),
            ),
            child: BText.caption(
              'Showing budgets for: ${_selectedTransactionTypes.map((t) => t.content(context)).join(', ')}',
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          gapH8,
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableBudgets.map((budget) {
            final isSelected = _selectedBudgetIds.contains(budget.id);
            IconModel iconModel = budget.iconModel;
            return BFilterChip(
              label: budget.name,
              iconModel: iconModel,
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedBudgetIds.add(budget.id);
                  } else {
                    _selectedBudgetIds.remove(budget.id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showDateRangePicker() async {
    final firstDate = widget.firstDate;
    final lastDate = widget.lastDate;

    final now = DateTime.now();
    final minDate = firstDate ?? DateTime(now.year - 1);
    final maxDate = lastDate ?? DateTime(now.year + 1);

    DateTimeRange initialRange = _selectedDateRange;

    if (initialRange.start.isBefore(minDate)) {
      final duration = initialRange.duration;
      DateTime newStart = minDate;
      DateTime newEnd = newStart.add(duration);

      if (newEnd.isAfter(maxDate)) {
        newEnd = maxDate;
        if (newEnd.difference(newStart).inDays < 1) {
          newStart = maxDate.subtract(const Duration(days: 30));
          if (newStart.isBefore(minDate)) {
            newStart = minDate;
          }
        }
      }

      initialRange = DateTimeRange(start: newStart, end: newEnd);
    }

    if (initialRange.end.isAfter(maxDate)) {
      final duration = initialRange.duration;
      DateTime newEnd = maxDate;
      DateTime newStart = newEnd.subtract(duration);

      if (newStart.isBefore(minDate)) {
        newStart = minDate;
        if (newEnd.difference(newStart).inDays < 1) {
          newEnd = minDate.add(const Duration(days: 30));
          if (newEnd.isAfter(maxDate)) {
            newEnd = maxDate;
          }
        }
      }

      initialRange = DateTimeRange(start: newStart, end: newEnd);
    }

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: minDate,
      lastDate: maxDate,
      initialDateRange: initialRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }
}
