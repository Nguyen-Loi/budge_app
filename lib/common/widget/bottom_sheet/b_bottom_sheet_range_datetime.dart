import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/bottom_sheet/b_bottom_sheet.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/localization/string_hardcoded.dart';
import 'package:budget_app/models/models_widget/range_datetime_model.dart';
import 'package:flutter/material.dart';

class BBottomsheetRangeDatetime extends StatefulWidget {
  const BBottomsheetRangeDatetime(
      {Key? key, required this.initialValue, required this.onChanged})
      : super(key: key);
  final void Function(RangeDatetimeModel rangeTime) onChanged;
  final RangeDateTimeEnum initialValue;

  @override
  State<BBottomsheetRangeDatetime> createState() =>
      _BBottomsheetRangeDatetimeState();
}

class _BBottomsheetRangeDatetimeState extends State<BBottomsheetRangeDatetime> {
  late RangeDatetimeModel _rangeDatetimeModel;
  late List<RangeDatetimeModel> _list;
  late String _title;

  Map<String, DateTime> getWeekRange(DateTime time) {
    int currentWeekday = time.weekday;
    DateTime firstDayOfWeek = time.subtract(Duration(days: currentWeekday - 1));
    DateTime lastDayOfWeek = time.add(Duration(days: 7 - currentWeekday));

    return {
      "firstDay": firstDayOfWeek,
      "lastDay": lastDayOfWeek,
    };
  }

  Map<String, DateTime> getMonthRange(DateTime time) {
    DateTime firstDayOfWeek = DateTime(time.year, time.month, 1);
    DateTime lastDayOfWeek = DateTime(time.year, time.month + 1, 0);

    return {
      "firstDay": firstDayOfWeek,
      "lastDay": lastDayOfWeek,
    };
  }

  Map<String, DateTime> getYearRange(DateTime time) {
    DateTime firstDayOfYear = DateTime(time.year, 1, 1);
    DateTime lastDayOfYear = DateTime(time.year, 12, 31);

    return {
      "firstDay": firstDayOfYear,
      "lastDay": lastDayOfYear,
    };
  }

  @override
  void initState() {
    final now = DateTime.now();
    final weekTime = getWeekRange(now);
    final monthTime = getMonthRange(now);
    final yearTime = getYearRange(now);
    _list = [
      RangeDatetimeModel(
          startDate: weekTime['firstDay']!,
          endDate: weekTime['lastDay']!,
          rangeDateTimeType: RangeDateTimeEnum.week),
      RangeDatetimeModel(
          startDate: monthTime['firstDay']!,
          endDate: monthTime['lastDay']!,
          rangeDateTimeType: RangeDateTimeEnum.month),
      RangeDatetimeModel(
          startDate: yearTime['firstDay']!,
          endDate: yearTime['lastDay']!,
          rangeDateTimeType: RangeDateTimeEnum.year),
      RangeDatetimeModel(
          startDate: monthTime['firstDay']!,
          endDate: monthTime['lastDay']!,
          rangeDateTimeType: RangeDateTimeEnum.custom),
    ];

    _rangeDatetimeModel =
        _list.firstWhere((e) => e.rangeDateTimeType == widget.initialValue);
    widget.onChanged(_rangeDatetimeModel);
    _loadTitle();
    super.initState();
  }

  void _loadTitle() {
    _title = _rangeDatetimeModel.rangeDateTimeType
        .content(rangeDatetimeModel: _rangeDatetimeModel);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(IconConstants.calendar),
      title: BText(_title),
      trailing: Icon(IconConstants.tap),
      onTap: () {
        BBottomSheet.show(context, builder: (context) {
          return _options(context);
        });
      },
    );
  }

  Widget _options(BuildContext context) {
    return Column(
      children: [
        BText.b1('Khoảng thời gian'.hardcoded, fontWeight: FontWeight.bold),
        gapH16,
        ColumnWithSpacing(
          children: _list
              .map((e) => RadioListTile(
                  value: e,
                  groupValue: _rangeDatetimeModel,
                  title:
                      BText(e.rangeDateTimeType.content(rangeDatetimeModel: e)),
                  onChanged: (e) {
                    if (e != null &&
                        e.rangeDateTimeType !=
                            _rangeDatetimeModel.rangeDateTimeType) {
                      setState(() {
                        widget.onChanged(e);
                        _rangeDatetimeModel = e;
                        _loadTitle();
                        logError(
                            _rangeDatetimeModel.rangeDateTimeType.toString());
                      });
                    }
                  }))
              .toList(),
        )
      ],
    );
  }
}
