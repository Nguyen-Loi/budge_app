import 'package:flutter/material.dart';

extension HandleDateTimeRange on DateTimeRange {
  bool isInBetweenDateTimeRange(DateTimeRange rangeDateTime) {
    return rangeDateTime.start.isAfter(start) ||
        rangeDateTime.start.isAtSameMomentAs(start) &&
            rangeDateTime.end.isBefore(end) ||
        rangeDateTime.end.isAtSameMomentAs(end);
  }
  
  // Overlap
  bool hasOverlapWith(DateTimeRange other) {
    DateTime current = start;
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if ((current.isAfter(other.start) ||
              current.isAtSameMomentAs(other.start)) &&
          (current.isBefore(other.end) ||
              current.isAtSameMomentAs(other.end))) {
        return true;
      }
      current = current.add(const Duration(days: 1));
    }
    return false;
  }
}
