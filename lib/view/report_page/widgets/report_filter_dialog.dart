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

  const ReportFilterDialog({
    super.key,
    required this.currentState,
    required this.availableBudgets,
    required this.availableTransactionTypes,
    required this.dateRangeOptions,
    this.firstDate,
    this.lastDate,
    required this.onFiltersChanged,
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: BText.h2(
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
          child: BText(context.loc.confirm),
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
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBudgetsSection() {
    bool hasSelectedBudgets =
        _selectedBudgetIds.length == widget.availableBudgets.length;
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
                  if (_selectedBudgetIds.length ==
                      widget.availableBudgets.length) {
                    _selectedBudgetIds.clear();
                  } else {
                    _selectedBudgetIds =
                        widget.availableBudgets.map((b) => b.id).toList();
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.availableBudgets.map((budget) {
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
    final now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: widget.firstDate ?? DateTime(now.year - 1),
      lastDate: widget.lastDate ?? DateTime(now.year),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }
}
