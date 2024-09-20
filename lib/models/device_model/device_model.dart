// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class DeviceModel {
  final String deviceName;
  final String operatingSystem;
  final bool isPhysicalDevice;
  final Map<String, dynamic> data;
  final DateTime createdDate;
  final DateTime updatedDate;
  DeviceModel({
    required this.deviceName,
    required this.operatingSystem,
    required this.isPhysicalDevice,
    required this.data,
    required this.createdDate,
    required this.updatedDate,
  });

  DeviceModel copyWith({
    String? deviceName,
    String? operatingSystem,
    bool? isPhysicalDevice,
    Map<String, dynamic>? data,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return DeviceModel(
      deviceName: deviceName ?? this.deviceName,
      operatingSystem: operatingSystem ?? this.operatingSystem,
      isPhysicalDevice: isPhysicalDevice ?? this.isPhysicalDevice,
      data: data ?? this.data,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deviceName': deviceName,
      'operatingSystem': operatingSystem,
      'isPhysicalDevice': isPhysicalDevice,
      'data': data,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
  }

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
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
    return 'DeviceModel(deviceName: $deviceName, operatingSystem: $operatingSystem, isPhysicalDevice: $isPhysicalDevice, data: $data, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant DeviceModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.deviceName == deviceName &&
      other.operatingSystem == operatingSystem &&
      other.isPhysicalDevice == isPhysicalDevice &&
      mapEquals(other.data, data) &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return deviceName.hashCode ^
      operatingSystem.hashCode ^
      isPhysicalDevice.hashCode ^
      data.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
