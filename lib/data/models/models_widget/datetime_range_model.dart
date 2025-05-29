import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';

class DatetimeRangeModel {
  final DateTime startDate;
  final DateTime endDate;
  final RangeDateTimeEnum rangeDateTimeType;
  DatetimeRangeModel({
    required this.startDate,
    required this.endDate,
    required this.rangeDateTimeType,
  });

  DatetimeRangeModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    RangeDateTimeEnum? rangeDateTimeType,
  }) {
    return DatetimeRangeModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rangeDateTimeType: rangeDateTimeType ?? this.rangeDateTimeType,
    );
  }

  @override
  String toString() =>
      'RangeDatetimeModel(startDate: $startDate, endDate: $endDate, rangeDateTimeType: $rangeDateTimeType)';

  @override
  bool operator ==(covariant DatetimeRangeModel other) {
    return other.rangeDateTimeType.value == rangeDateTimeType.value &&
        other.startDate.isSameDate(startDate) &&
        other.endDate.isSameDate(endDate);
  }

  @override
  int get hashCode =>
      startDate.hashCode ^ endDate.hashCode ^ rangeDateTimeType.hashCode;
}
