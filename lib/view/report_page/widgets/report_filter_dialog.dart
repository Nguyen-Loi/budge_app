import 'package:budget_app/common/widget/b_filter_chip.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/data/models/models_widget/icon_model.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/report_page/controller/report_filter_model.dart';
import 'package:flutter/material.dart';

class ReportFilterDialog extends StatefulWidget {
  final ReportFilterModel currentState;
  final List<BudgetTransactionsModel> availableBudgetsTransactions;
  final DateTimeRange availableDateRange;
  final Function(DateTimeRange?, List<BudgetTypeEnum>?, List<String>?)
      onChanged;

  const ReportFilterDialog({
    super.key,
    required this.currentState,
    required this.availableBudgetsTransactions,
    required this.onChanged,
    required this.availableDateRange,
  });

  @override
  State<ReportFilterDialog> createState() => _ReportFilterDialogState();
}

class _ReportFilterDialogState extends State<ReportFilterDialog> {
  late DateTimeRange _selectedDateRange;
  late List<BudgetTypeEnum> _selectedBudgetTypes;

  late List<String> _selectedBudgetIds;
  late List<BudgetModel> _budgetsCanSelect;

  late List<BudgetTransactionsModel> _availableBudgetsTransactions;
  late DateTimeRange _availableDateRange;

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.currentState.dateTimeRangePicker;
    _selectedBudgetTypes = List.from(widget.currentState.budgetTypes);
    _availableBudgetsTransactions = widget.availableBudgetsTransactions;
    _availableDateRange = widget.availableDateRange;
    _updateBudgetList(isInitial: true);
  }

  void _updateBudgetList({bool isInitial = false}) {
    final budgetsFilter = _availableBudgetsTransactions
        .getBudgetActive(_selectedDateRange)
        .where((b) => _selectedBudgetTypes.contains(b.budgetType))
        .toList();
    _budgetsCanSelect = budgetsFilter;
    if (isInitial) {
      _selectedBudgetIds = List.from(widget.currentState.selectedBudgetIds);
      return;
    } else {
      _selectedBudgetIds = _selectedBudgetIds
          .where((id) => budgetsFilter.any((budget) => budget.id == id))
          .toList();
    }
  }

  List<BudgetTypeEnum> get _availableTransactionTypes => BudgetTypeEnum.values;

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
        BButton.outlined(
          onPressed: () => Navigator.of(context).pop(),
          title: context.loc.cancel,
          maxWidth: 120,
        ),
        BButton(
          maxWidth: 120,
          onPressed: () {
            final initFilter = widget.currentState;
            final changedDate =
                _selectedDateRange != initFilter.dateTimeRangePicker;

            final changedTypes =
                _selectedBudgetTypes.length != initFilter.budgetTypes.length ||
                    !_selectedBudgetTypes
                        .toSet()
                        .containsAll(initFilter.budgetTypes);

            final changedIds = _selectedBudgetIds.length !=
                    initFilter.selectedBudgetIds.length ||
                !_selectedBudgetIds
                    .toSet()
                    .containsAll(initFilter.selectedBudgetIds);

            final isChangedFilter = changedDate || changedTypes || changedIds;

            if (isChangedFilter) {
              widget.onChanged(
                _selectedDateRange,
                _selectedBudgetTypes,
                _selectedBudgetIds,
              );
            }
            Navigator.of(context).pop();
          },
          title: context.loc.confirm,
        )
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
          children: _availableTransactionTypes.map((type) {
            final isSelected = _selectedBudgetTypes.contains(type);
            return BFilterChip(
              label: type.content(context),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedBudgetTypes.add(type);
                  } else {
                    _selectedBudgetTypes.remove(type);
                  }

                  _updateBudgetList();
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBudgetsSection() {
    final hasSelectedBudgets =
        _selectedBudgetIds.length == _availableBudgetsTransactions.length;

    if (_availableBudgetsTransactions.isEmpty) {
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
                  if (_selectedBudgetIds.length == _budgetsCanSelect.length) {
                    _selectedBudgetIds.clear();
                  } else {
                    _selectedBudgetIds =
                        _budgetsCanSelect.map((b) => b.id).toList();
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
        if (_selectedBudgetTypes.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(50),
              borderRadius: BorderRadius.circular(6),
            ),
            child: BText.caption(
              '${context.loc.pShowingBudgetsFor(_selectedBudgetTypes.map((t) => t.content(context)).join(', '))} (${_selectedDateRange.start.toFormatDate()} - ${_selectedDateRange.end.toFormatDate()})',
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          gapH8,
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _budgetsCanSelect.map((budget) {
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
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: _availableDateRange.start,
      lastDate: _availableDateRange.end,
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _updateBudgetList();
      });
    }
  }
}
