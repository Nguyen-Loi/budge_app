import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/models_widget/datetime_range_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

enum RangeDateTimeEnum {
  allTime('ALL_TIME'),
  week('WEEK'),
  month('MONTH'),
  year('YEAR'),
  custom('CUSTOM'),
  ;

  factory RangeDateTimeEnum.fromValue(String value) {
    return RangeDateTimeEnum.values
        .firstWhereOrNull((element) => element.value==value.toUpperCase())??RangeDateTimeEnum.allTime;
  }

  String content(BuildContext context,
      {required DatetimeRangeModel rangeDatetimeModel}) {
    switch (rangeDatetimeModel.rangeDateTimeType) {
      case RangeDateTimeEnum.allTime:
        return context.loc.allTime;
      case RangeDateTimeEnum.week:
        String strFormat = 'MM/dd';
        return context.loc.pThisWeek(
            rangeDatetimeModel.startDate.toFormatDate(strFormat: strFormat),
            rangeDatetimeModel.endDate.toFormatDate(strFormat: strFormat));
      case RangeDateTimeEnum.month:
        String strFormat = 'dd/MM/yyyy';
        return context.loc.pThisMonth(
            rangeDatetimeModel.startDate.toFormatDate(strFormat: strFormat),
            rangeDatetimeModel.endDate.toFormatDate(strFormat: strFormat));
      case RangeDateTimeEnum.year:
        String strFormat = 'dd/MM/yyyy';
        return context.loc.pThisYear(
            rangeDatetimeModel.startDate.toFormatDate(strFormat: strFormat),
            rangeDatetimeModel.endDate.toFormatDate(strFormat: strFormat));
      case RangeDateTimeEnum.custom:
        String strFormat = 'dd/MM/yyyy';
        return context.loc.pThisDayTimeCustom(
            rangeDatetimeModel.startDate.toFormatDate(strFormat: strFormat),
            rangeDatetimeModel.endDate.toFormatDate(strFormat: strFormat));
    }
  }

  final String value;
  const RangeDateTimeEnum(this.value);
}
