import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/models/models_widget/datetime_range_model.dart';
import 'package:flutter/material.dart';

class BBottomsheetRangeDatetime extends StatefulWidget {
  const BBottomsheetRangeDatetime(
      {Key? key, required this.initialValue, required this.onChanged})
      : super(key: key);
  final void Function(DatetimeRangeModel rangeTime) onChanged;
  final RangeDateTimeEnum initialValue;

  @override
  State<BBottomsheetRangeDatetime> createState() =>
      _BBottomsheetRangeDatetimeState();
}

class _BBottomsheetRangeDatetimeState extends State<BBottomsheetRangeDatetime> {
  late DatetimeRangeModel _rangeDatetimeModelSelected;
  late DatetimeRangeModel _rangeDatetimeModelCurrent;

  late List<DatetimeRangeModel> _list;
  late String _title;
  final now = DateTime.now();

  DatetimeRangeModel getWeekRange(DateTime time) {
    int currentWeekday = time.weekday;
    DateTime firstDayOfWeek = time.subtract(Duration(days: currentWeekday - 1));
    DateTime lastDayOfWeek = time.add(Duration(days: 7 - currentWeekday));
    return DatetimeRangeModel(
        startDate: firstDayOfWeek,
        endDate: lastDayOfWeek,
        rangeDateTimeType: RangeDateTimeEnum.week);
  }

  DatetimeRangeModel getMonthRange(DateTime time) {
    DateTime firstDayOfMonth = DateTime(time.year, time.month, 1);
    DateTime lastDayOfMonth = DateTime(time.year, time.month + 1, 0);
    return DatetimeRangeModel(
        startDate: firstDayOfMonth,
        endDate: lastDayOfMonth,
        rangeDateTimeType: RangeDateTimeEnum.month);
  }

  DatetimeRangeModel getYearRange(DateTime time) {
    DateTime firstDayOfYear = DateTime(time.year, 1, 1);
    DateTime lastDayOfYear = DateTime(time.year, 12, 31);
    return DatetimeRangeModel(
        startDate: firstDayOfYear,
        endDate: lastDayOfYear,
        rangeDateTimeType: RangeDateTimeEnum.year);
  }

  @override
  void initState() {
    _list = [
      getWeekRange(now),
      getMonthRange(now),
      getYearRange(now),
      getMonthRange(now).copyWith(rangeDateTimeType: RangeDateTimeEnum.custom),
    ];

    _rangeDatetimeModelSelected =
        _list.firstWhere((e) => e.rangeDateTimeType == widget.initialValue);
    _rangeDatetimeModelCurrent = _rangeDatetimeModelSelected;
    widget.onChanged(_rangeDatetimeModelSelected);
    _loadTitle();
    super.initState();
  }

  void _loadTitle() {
    _title = _rangeDatetimeModelCurrent.rangeDateTimeType
        .content(rangeDatetimeModel: _rangeDatetimeModelCurrent);
  }

  void _save() {
    _rangeDatetimeModelCurrent = _rangeDatetimeModelSelected;
    setState(() {
      _loadTitle();
    });

    widget.onChanged(_rangeDatetimeModelCurrent);
    Navigator.pop(context);
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
                      _buttons()
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
            border: Border.all(color: ColorManager.grey1, width: 0.6)),
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
                _rangeDatetimeModelSelected = _rangeDatetimeModelCurrent;
                Navigator.of(context).pop();
              },
              child: BText('Hủy'.hardcoded),
            ),
          ),
          gapW16,
          SizedBox(
            width: 130,
            child: FilledButton(
              onPressed: _save,
              child: BText('Lưu'.hardcoded, color: ColorManager.white),
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

      DatetimeRangeModel newData = DatetimeRangeModel(
          startDate: newDateRangeCustom.start,
          endDate: newDateRangeCustom.end,
          rangeDateTimeType: RangeDateTimeEnum.custom);
      stateSetter(() {
        _list[3] = newData;
        _rangeDatetimeModelSelected = newData;
      });
      return;
    }

    //
    if (e.rangeDateTimeType != _rangeDatetimeModelSelected.rangeDateTimeType) {
      stateSetter(() {
        _rangeDatetimeModelSelected = e;
      });
    }
  }

  Widget _options(BuildContext context, {required StateSetter stateSetter}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BText.b1('Khoảng thời gian'.hardcoded, fontWeight: FontWeight.bold),
        gapH16,
        ColumnWithSpacing(
          mainAxisSize: MainAxisSize.min,
          children: _list.map((e) {
            String title = e.rangeDateTimeType.content(rangeDatetimeModel: e);
            bool isChooseCustom =
                e.rangeDateTimeType == RangeDateTimeEnum.custom &&
                    _rangeDatetimeModelSelected.rangeDateTimeType ==
                        RangeDateTimeEnum.custom;
            if (e.rangeDateTimeType == RangeDateTimeEnum.custom) {
              title = 'Tùy chỉnh';
            }

            // For custom

            String customFormat = 'dd/MM/yyyy';
            final dateRangeCustom = _list[3];
            String dateRangeForCustom =
                '${dateRangeCustom.startDate.toFormatDate(strFormat: customFormat)} - ${dateRangeCustom.endDate.toFormatDate(strFormat: customFormat)}';
            return RadioListTile(
                value: e,
                groupValue: _rangeDatetimeModelSelected,
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
