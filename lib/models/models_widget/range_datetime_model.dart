import 'package:budget_app/core/enums/range_date_time_enum.dart';

class RangeDatetimeModel {
  final DateTime startDate;
  final DateTime endDate;
  final RangeDateTimeEnum rangeDateTimeType;
  RangeDatetimeModel({
    required this.startDate,
    required this.endDate,
    required this.rangeDateTimeType,
  });

  RangeDatetimeModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    RangeDateTimeEnum? rangeDateTimeType,
  }) {
    return RangeDatetimeModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rangeDateTimeType: rangeDateTimeType ?? this.rangeDateTimeType,
    );
  }

  @override
  String toString() =>
      'RangeDatetimeModel(startDate: $startDate, endDate: $endDate, rangeDateTimeType: $rangeDateTimeType)';

  @override
  bool operator ==(covariant RangeDatetimeModel other) {
    return other.rangeDateTimeType.value == rangeDateTimeType.value;
  }

  @override
  int get hashCode =>
      startDate.hashCode ^ endDate.hashCode ^ rangeDateTimeType.hashCode;
}
