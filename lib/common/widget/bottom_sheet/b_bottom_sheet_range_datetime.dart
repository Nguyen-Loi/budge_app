import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/models_widget/datetime_range_model.dart';
import 'package:flutter/material.dart';

class BBottomsheetRangeDatetime extends StatefulWidget {
  const BBottomsheetRangeDatetime(
      {super.key, required this.initialValue, required this.onChanged});
  final void Function(DatetimeRangeModel rangeTime) onChanged;
  final DatetimeRangeModel? initialValue;

  @override
  State<BBottomsheetRangeDatetime> createState() =>
      _BBottomsheetRangeDatetimeState();
}

class _BBottomsheetRangeDatetimeState extends State<BBottomsheetRangeDatetime> {
  late DatetimeRangeModel _rangeDatetimeModelInit;
  late DatetimeRangeModel _rangeDatetimeModelSelected;

  late List<DatetimeRangeModel> _list;
  String _title = '';
  final now = DateTime.now();
  DatetimeRangeModel get _defaultValue => getAllTime;

  DatetimeRangeModel get getAllTime {
    return DatetimeRangeModel(
        startDate: DateTime(now.year, now.month, now.day),
        endDate: DateTime(9999, 01, 01),
        rangeDateTimeType: RangeDateTimeEnum.allTime);
  }

  DatetimeRangeModel getWeekRange(DateTime time) {
    final weekRange = time.getRangeWeek;
    return DatetimeRangeModel(
        startDate: weekRange.start,
        endDate: weekRange.end,
        rangeDateTimeType: RangeDateTimeEnum.week);
  }

  DatetimeRangeModel getMonthRange(DateTime time) {
    final monRange = time.getRangeMonth;
    return DatetimeRangeModel(
        startDate: monRange.start,
        endDate: monRange.end,
        rangeDateTimeType: RangeDateTimeEnum.month);
  }

  DatetimeRangeModel getYearRange(DateTime time) {
    final yearRange = time.getRangeYear;
    return DatetimeRangeModel(
        startDate: yearRange.start,
        endDate: yearRange.end,
        rangeDateTimeType: RangeDateTimeEnum.year);
  }

  DatetimeRangeModel getCustomRange() {
    final initValue = widget.initialValue;
    if (initValue != null &&
        initValue.rangeDateTimeType == RangeDateTimeEnum.custom) {
      return DatetimeRangeModel(
          startDate: initValue.startDate,
          endDate: initValue.endDate,
          rangeDateTimeType: RangeDateTimeEnum.custom);
    }
    return getMonthRange(now)
        .copyWith(rangeDateTimeType: RangeDateTimeEnum.custom);
  }

  @override
  void initState() {
    _list = [
      getAllTime,
      // getWeekRange(now),
      getMonthRange(now),
      getYearRange(now),
      getCustomRange()
    ];

    _rangeDatetimeModelInit = widget.initialValue ?? _defaultValue;

    _rangeDatetimeModelSelected = _rangeDatetimeModelInit;
    widget.onChanged(_rangeDatetimeModelInit);
    Future.delayed(Duration.zero, () {
      setState(() {
        _loadTitle();
      });
    });
    context;
    super.initState();
  }

  void _loadTitle() {
    _title = _rangeDatetimeModelSelected.rangeDateTimeType
        .content(context, rangeDatetimeModel: _rangeDatetimeModelSelected);
  }

  void _save() {
    if (!_validate()) {
      return;
    }
    _rangeDatetimeModelSelected = _rangeDatetimeModelInit;
    setState(() {
      _loadTitle();
    });

    widget.onChanged(_rangeDatetimeModelSelected);
    Navigator.pop(context);
  }

  bool _validate() {
    DatetimeRangeModel currentTime = _rangeDatetimeModelInit;
    DatetimeRangeModel newTime = _rangeDatetimeModelSelected;
    bool isInitValue = widget.initialValue == null;
    if ((newTime.startDate.isBefore(currentTime.startDate) ||
            newTime.endDate.isAfter(currentTime.endDate)) &&
        !isInitValue) {
      Navigator.pop(context);
      showSnackBar(context, context.loc.invalidDateRange);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showModalBottomSheet(
            context: context,
            isDismissible: false,
            builder: (context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter stateSetter) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _options(context, stateSetter: stateSetter),
                      gapH16,
                      _buttons(),
                      gapH16
                    ],
                  ),
                );
              });
            });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(color: ColorManager.primary, width: 0.6)),
        child: Row(
          children: [
            Icon(IconManager.calendar),
            gapW16,
            Expanded(child: BText(_title)),
            gapW8,
            Icon(IconManager.tap)
          ],
        ),
      ),
    );
  }

  Widget _buttons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 130,
            child: OutlinedButton(
              onPressed: () {
                _rangeDatetimeModelInit = _rangeDatetimeModelSelected;
                Navigator.of(context).pop();
              },
              child: BText(context.loc.cancel),
            ),
          ),
          gapW16,
          SizedBox(
            width: 130,
            child: FilledButton(
              onPressed: _save,
              child: BText(context.loc.save, color: ColorManager.white),
            ),
          )
        ],
      ),
    );
  }

  void updateState(
      {required BuildContext context,
      required DatetimeRangeModel? e,
      required StateSetter stateSetter}) async {
    if (e == null) {
      return;
    }
    // If choose type custom then picker dialog
    if (e.rangeDateTimeType == RangeDateTimeEnum.custom) {
      DateTimeRange? newDateRangeCustom = await showDateRangePicker(
        context: context,
        initialDateRange:
            DateTimeRange(start: _list[3].startDate, end: _list[3].endDate),
        firstDate: DateTime(now.year, now.month - 2),
        lastDate: DateTime(now.year + 1),
      );
      if (newDateRangeCustom == null) {
        return;
      }

      final endDate = newDateRangeCustom.end;

      DatetimeRangeModel newData = DatetimeRangeModel(
          startDate: newDateRangeCustom.start,
          endDate:
              DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59),
          rangeDateTimeType: RangeDateTimeEnum.custom);
      stateSetter(() {
        _list[3] = newData;
        _rangeDatetimeModelInit = newData;
      });
      return;
    }

    //
    if (e.rangeDateTimeType != _rangeDatetimeModelInit.rangeDateTimeType) {
      stateSetter(() {
        _rangeDatetimeModelInit = e;
      });
    }
  }

  Widget _options(BuildContext context, {required StateSetter stateSetter}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BText.b1(context.loc.dateRange, fontWeight: FontWeight.bold),
        gapH16,
        ColumnWithSpacing(
          mainAxisSize: MainAxisSize.min,
          children: _list.map((e) {
            String title =
                e.rangeDateTimeType.content(context, rangeDatetimeModel: e);
            bool isChooseCustom =
                e.rangeDateTimeType == RangeDateTimeEnum.custom &&
                    _rangeDatetimeModelInit.rangeDateTimeType ==
                        RangeDateTimeEnum.custom;
            if (e.rangeDateTimeType == RangeDateTimeEnum.custom) {
              title = context.loc.custom;
            }

            // For custom

            String customFormat = 'dd/MM/yyyy';
            final dateRangeCustom = _list[3];
            String dateRangeForCustom =
                '${dateRangeCustom.startDate.toFormatDate(strFormat: customFormat)} - ${dateRangeCustom.endDate.toFormatDate(strFormat: customFormat)}';
            return RadioListTile(
                value: e,
                groupValue: _rangeDatetimeModelInit,
                title: isChooseCustom
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BText(title),
                          gapH16,
                          BText(
                            dateRangeForCustom,
                          )
                        ],
                      )
                    : BText(title),
                onChanged: (e) async {
                  updateState(context: context, e: e, stateSetter: stateSetter);
                });
          }).toList(),
        )
      ],
    );
  }
}
