import 'package:budget_app/common/widget/dropdown/b_dropdown.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/models/models_widget/range_datetime_model.dart';
import 'package:flutter/material.dart';

class BDropdownRangeDatetime extends StatelessWidget {
  const BDropdownRangeDatetime({Key? key, required this.onChanged})
      : super(key: key);
  final void Function(RangeDatetimeModel rangeTime) onChanged;

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

  List<RangeDatetimeModel> get list {
    final now = DateTime.now();
    final weekTime = getWeekRange(now);
    final monthTime = getMonthRange(now);
    final yearTime = getYearRange(now);
    return [
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
  }

  @override
  Widget build(BuildContext context) {
    return BDropdown<RangeDatetimeModel>(
        inittialValue: list.first,
        label: (e) => e!.rangeDateTimeType.content(rangeDatetimeModel: e),
        items: list,
        onChanged: (e) {
          onChanged(e!);
        });
  }
}
