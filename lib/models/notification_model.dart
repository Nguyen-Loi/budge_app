import 'dart:convert';

import 'package:budget_app/core/enums/notification_priority_enum.dart';
import 'package:budget_app/core/enums/notification_status_enum.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String? title;
  final String? message;
  final String? urlImage;
  final String priorityTypeValue;
  final String statusValue;
  final DateTime? readAt;
  final DateTime createdDate;
  NotificationModel({
    required this.id,
    required this.userId,
    this.title,
    this.message,
    this.urlImage,
    required this.priorityTypeValue,
    required this.statusValue,
    this.readAt,
    required this.createdDate,
  });

  NotificationStatusEnum get notificationStatus =>
      NotificationStatusEnum.values.firstWhere((e) => e.value == statusValue);

  NotificationPriorityEnum get notificationPriority =>
      NotificationPriorityEnum.values
          .firstWhere((e) => e.value == priorityTypeValue);

  factory NotificationModel.fromRemoteMessage(RemoteMessage remoteMessage) {
    return NotificationModel(
      id: remoteMessage.messageId ?? '',
      userId: remoteMessage.data['userId'] ?? '',
      title: remoteMessage.notification?.title,
      message: remoteMessage.notification?.body,
      urlImage: remoteMessage.notification?.android?.imageUrl,
      priorityTypeValue: remoteMessage.data['priority'] ?? '',
      statusValue: remoteMessage.data['status'] ?? '',
      readAt: null,
      createdDate: DateTime.now(),
    );
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? urlImage,
    String? priorityTypeValue,
    String? statusValue,
    DateTime? readAt,
    DateTime? createdDate,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      urlImage: urlImage ?? this.urlImage,
      priorityTypeValue: priorityTypeValue ?? this.priorityTypeValue,
      statusValue: statusValue ?? this.statusValue,
      readAt: readAt ?? this.readAt,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'urlImage': urlImage,
      'priorityTypeValue': priorityTypeValue,
      'statusValue': statusValue,
      'readAt': readAt?.millisecondsSinceEpoch,
      'createdDate': createdDate.millisecondsSinceEpoch,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] != null ? map['title'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      urlImage: map['urlImage'] != null ? map['urlImage'] as String : null,
      priorityTypeValue: map['priorityTypeValue'] as String,
      statusValue: map['statusValue'] as String,
      readAt: map['readAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['readAt'] as int)
          : null,
      createdDate:
          DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, title: $title, message: $message, urlImage: $urlImage, priorityTypeValue: $priorityTypeValue, statusValue: $statusValue, readAt: $readAt, createdDate: $createdDate)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.message == message &&
        other.urlImage == urlImage &&
        other.priorityTypeValue == priorityTypeValue &&
        other.statusValue == statusValue &&
        other.readAt == readAt &&
        other.createdDate == createdDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        message.hashCode ^
        urlImage.hashCode ^
        priorityTypeValue.hashCode ^
        statusValue.hashCode ^
        readAt.hashCode ^
        createdDate.hashCode;
  }
}
