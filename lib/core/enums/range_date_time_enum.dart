import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/models/models_widget/range_datetime_model.dart';

enum RangeDateTimeEnum {
  week(1),
  month(2),
  year(3),
  custom(4);

  factory RangeDateTimeEnum.fromValue(int value) {
    return RangeDateTimeEnum.values
        .firstWhere((element) => element.value == value);
  }

  String content({required RangeDatetimeModel rangeDatetimeModel}) {
    switch (rangeDatetimeModel.rangeDateTimeType) {
      case RangeDateTimeEnum.week:
        String strFormat = 'MM/dd';
        return 'Tuần này (${rangeDatetimeModel.startDate.toFormatDate(strFormat: strFormat)} - ${rangeDatetimeModel.endDate.toFormatDate(strFormat: strFormat)})';
      case RangeDateTimeEnum.month:
       String strFormat = 'MM/dd';
        return 'Tháng này (${rangeDatetimeModel.startDate.toFormatDate(strFormat: strFormat)} - ${rangeDatetimeModel.endDate.toFormatDate(strFormat: strFormat)})';
      case RangeDateTimeEnum.year:
        String strFormat = 'dd/MM/yyyy';
        return 'Năm nay (${rangeDatetimeModel.startDate.toFormatDate(strFormat: strFormat)} - ${rangeDatetimeModel.endDate.toFormatDate(strFormat: strFormat)})';
      case RangeDateTimeEnum.custom:
      String strFormat = 'dd/MM/yyyy';
        return 'Tùy chỉnh (${rangeDatetimeModel.startDate.toFormatDate(strFormat: strFormat)} - ${rangeDatetimeModel.endDate.toFormatDate(strFormat: strFormat)})';
    }
  }

  final int value;
  const RangeDateTimeEnum(this.value);
}
