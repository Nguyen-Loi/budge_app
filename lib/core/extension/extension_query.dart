import 'package:cloud_firestore/cloud_firestore.dart';

extension QueryFilterDb on CollectionReference<Map<String, dynamic>> {
  Query<Map<String, dynamic>> filterByMonth(
      {String field = 'createdDate', required DateTime time}) {
    DateTime startDate = DateTime(time.year, time.month, 1);
    DateTime endDate = DateTime(time.year, time.month + 1);
    return where(field, isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch)
        .where(field, isLessThanOrEqualTo: endDate.millisecondsSinceEpoch);
  }
}
