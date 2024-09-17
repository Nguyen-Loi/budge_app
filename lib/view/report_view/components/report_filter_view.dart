import 'package:budget_app/common/widget/b_app_bar.dart';
import 'package:budget_app/common/widget/filter/b_filter_multiple_select_item.dart';
import 'package:budget_app/common/widget/filter/b_filter_single_select_item.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';

class ReportFilterModel {
  final DateTimeRange dateTimeRange;
  final List<TransactionTypeEnum> transactionTypes;

  ReportFilterModel({
    required this.dateTimeRange,
    required this.transactionTypes,
  });

  ReportFilterModel copyWith({
    DateTimeRange? dateTimeRange,
    List<TransactionTypeEnum>? transactionTypes,
  }) {
    return ReportFilterModel(
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      transactionTypes: transactionTypes ?? this.transactionTypes,
    );
  }

  @override
  String toString() =>
      'ReportModel(dateTimeRange: $dateTimeRange, transactionTypes: $transactionTypes)';
}

class ReportFilterView extends StatefulWidget {
  const ReportFilterView(
      {super.key,
      required this.init,
      required this.values,
      required this.onChanged});
  final ReportFilterModel init;
  final ReportFilterModel values;
  final ValueChanged<ReportFilterModel> onChanged;

  @override
  State<ReportFilterView> createState() => _ReportFilterViewState();
}

class _ReportFilterViewState extends State<ReportFilterView> {
  late ReportFilterModel _initFilterModel;
  late ReportFilterModel _valueFilterModel;

  List<DateTimeRange> get rangeDateTimeEveryMonth {
    List<DateTimeRange> ranges = [];
    DateTime start = _valueFilterModel.dateTimeRange.start;
    DateTime end = _valueFilterModel.dateTimeRange.end;

    DateTime current = DateTime(start.year, start.month);
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      DateTime monthEnd = DateTime(current.year, current.month + 1, 0);
      if (monthEnd.isAfter(end)) {
        monthEnd = end;
      }
      ranges.add(DateTimeRange(start: current, end: monthEnd));
      current = DateTime(current.year, current.month + 1);
    }
    return ranges;
  }

  @override
  void initState() {
    _valueFilterModel = widget.values;
    _initFilterModel = widget.init;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(text: 'Filter'.hardcoded),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            gapH24,
            Expanded(
              child: _listField(),
            ),
            gapH16,
            _action(),
            gapH24,
          ],
        ),
      ),
    );
  }

  Widget _action() {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: ColorManager.grey1,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
            onPressed: () => Navigator.of(context).pop(),
            child: BText.b1(
              context.loc.cancel,
              color: ColorManager.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
            onPressed: () {
              widget.onChanged(_initFilterModel);
              Navigator.of(context).pop();
            },
            child: BText.b1(
              'Accept'.hardcoded,
              color: ColorManager.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _listField() {
    return ColumnWithSpacing(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _baseItem(
            label: 'Choose month'.hardcoded,
            item: BFilterSingleSelectItem<DateTimeRange>(
                values: rangeDateTimeEveryMonth,
                init: _initFilterModel.dateTimeRange,
                onChanged: (model) {
                  _initFilterModel =
                      _initFilterModel.copyWith(dateTimeRange: model);
                },
                label: (model) =>
                    model!.start.toFormatDate(strFormat: 'MM-yyyy'))),
        _baseItem(
            label: 'Choose budgets'.hardcoded,
            item: BFilterMultipleSelectItem<TransactionTypeEnum>(
                values: _valueFilterModel.transactionTypes,
                init: _initFilterModel.transactionTypes,
                onChanged: (values) {
                  _initFilterModel =
                      _initFilterModel.copyWith(transactionTypes: values);
                },
                label: (transactionType) => transactionType!.content(context)))
      ],
    );
  }

  Widget _baseItem({required String label, required Widget item}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BText(
          label,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 16),
        Align(alignment: Alignment.center, child: item)
      ],
    );
  }
}
