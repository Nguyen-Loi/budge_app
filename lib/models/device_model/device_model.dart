// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:budget_app/core/enums/device_type_enum.dart';

class DeviceModel {
  final String id;
  final String userId;
  final String deviceName;
  final String operatingSystem;
  final bool isPhysicalDevice;
  final Map<String, dynamic> data;
  final DateTime createdDate;
  final DateTime updatedDate;
  DeviceModel({
    required this.id,
    required this.userId,
    required this.deviceName,
    required this.operatingSystem,
    required this.isPhysicalDevice,
    required this.data,
    required this.createdDate,
    required this.updatedDate,
  });
  

  DeviceTypeEnum get deviceType =>
      DeviceTypeEnum.values.firstWhere((e) => e.value == operatingSystem);


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'deviceName': deviceName,
      'operatingSystem': operatingSystem,
      'isPhysicalDevice': isPhysicalDevice,
      'data': data,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
  }



  bool infoDeviceIsExist(List<DeviceModel> devices) {
    for (var e in devices) {
      if (e == this) {
        return true;
      }
    }
    return false;
  }

  DeviceModel copyWith({
    String? id,
    String? userId,
    String? deviceName,
    String? operatingSystem,
    bool? isPhysicalDevice,
    Map<String, dynamic>? data,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceName: deviceName ?? this.deviceName,
      operatingSystem: operatingSystem ?? this.operatingSystem,
      isPhysicalDevice: isPhysicalDevice ?? this.isPhysicalDevice,
      data: data ?? this.data,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      deviceName: map['deviceName'] as String,
      operatingSystem: map['operatingSystem'] as String,
      isPhysicalDevice: map['isPhysicalDevice'] as bool,
      data: Map<String, dynamic>.from((map['data'] as Map<String, dynamic>)),
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate: DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceModel.fromJson(String source) => DeviceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeviceModel(id: $id, userId: $userId, deviceName: $deviceName, operatingSystem: $operatingSystem, isPhysicalDevice: $isPhysicalDevice, data: $data, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant DeviceModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.deviceName == deviceName &&
      other.operatingSystem == operatingSystem &&
      other.isPhysicalDevice == isPhysicalDevice &&
      mapEquals(other.data, data) &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      deviceName.hashCode ^
      operatingSystem.hashCode ^
      isPhysicalDevice.hashCode ^
      data.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
