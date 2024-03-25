import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension Find<K, V, R> on Map<K, V> {
  ///Return the string
  R find(K key, R Function(String value) cast, {Object? defaultValue}) {
    try {
      final value = this[key];
      if (value != null) {
        return cast(value.toString());
      } else {
        if (defaultValue != null) {
          return cast(defaultValue.toString());
        }
      }
    } catch (_) {
      return cast(defaultValue.toString());
    }
    return cast(defaultValue.toString());
  }

  ///Return by dataType
  R findData<T>(K key, R Function(T value) cast, {Object? defaultValue}) {
    R defaultTemp = cast(defaultValue as T);
    try {
      final value = this[key];
      if (value != null && value is T) {
        return cast(value as T);
      } else {
        if (defaultValue != null) {
          return defaultTemp;
        }
      }
    } catch (_) {
      return defaultTemp;
    }
    return defaultTemp;
  }
}

class Methods {
  Methods._();
  static double getDouble(Map data, String fieldName,
      {double defaultValue = 0.0}) {
    return data.find(fieldName, (value) => double.parse(value),
        defaultValue: defaultValue);
  }

  static dynamic getDynamic(Map data, String fieldName,
      {dynamic defaultValue}) {
    return data.findData(fieldName, (value) => value,
        defaultValue: defaultValue);
  }

  static int getInt(Map data, String fieldName, {int defaultValue = 0}) {
    return data.find(fieldName, (value) => double.parse(value).toInt(),
        defaultValue: defaultValue);
  }

  static int getIntRound(Map data, String fieldName, {int defaultValue = 0}) {
    return data.find(fieldName, (value) => double.parse(value).round(),
        defaultValue: defaultValue);
  }

  static String getString(Map data, String fieldName,
      {String defaultValue = ''}) {
    return data.find(fieldName, (value) => value, defaultValue: defaultValue);
  }

  static bool getBool(Map data, String fieldName, {bool defaultValue = false}) {
    return data.find(fieldName, (value) {
      if (value == 'true' || value == '1') {
        return true;
      }
      return false;
    });
  }

  static DateTime? getDateTime(Map data, String fieldName,
      {DateTime? defaultValue}) {
    if (data[fieldName] == null) {
      return null;
    } else if (data[fieldName] is DateTime) {
      return data[fieldName];
    } else if (data[fieldName] is Timestamp) {
      Timestamp va = data[fieldName];
      return va.toDate();
    } else {
      return null;
    }
  }

  static String strTimeStamp(Map data, String fieldName,
      {String defaultFormat = 'hh:mm dd/MM/yyyy', String? defaultValue}) {
    int timeStampInt = getInt(data, fieldName);
    if (timeStampInt == 0) {
      return defaultValue ?? 'null';
    }
    DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(timeStampInt);

    return DateFormat(defaultFormat).format(
      timeStamp,
    );
  }

  static List<T> getList(Map data, String fieldName) {
    return data.findData(fieldName, (value) => value, defaultValue: []);
  }

  static List<Map<String, bool>> getListStrBool(Map data, String fieldName) {
    dynamic listTimeData = data[fieldName];

    if (listTimeData is List) {
      return List<Map<String, bool>>.from(listTimeData.map((item) {
        if (item is Map<String, dynamic>) {
          return Map<String, bool>.from(item.map((key, value) {
            if (value is bool) {
              return MapEntry(key, value);
            } else {
              return MapEntry(
                  key, false); 
            }
          }));
        } else {
      
          return {}; 
        }
      }));
    } else {
      return [];
    }
  }

  static List<String> getListString(Map data, String fieldName) {
    return data.findData(
        fieldName, (value) => (value as List).map((e) => e.toString()).toList(),
        defaultValue: []);
  }

  ///String => int
  static int convertToInt(Map data, String fieldName) {
    return data.find(
        fieldName, (value) => value.replaceAll(RegExp(r'[^0-9]'), ''));
  }
}
