import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigModel {
  final String geminiApiKey;
  final String recommendedMinimumVersion;
  final String requiredMinimumVersion;

  RemoteConfigModel({
    required this.geminiApiKey,
    required this.recommendedMinimumVersion,
    required this.requiredMinimumVersion,
  });

  RemoteConfigModel copyWith({
    String? geminiApiKey,
    String? recommendedMinimumVersion,
    String? requiredMinimumVersion,
  }) {
    return RemoteConfigModel(
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      recommendedMinimumVersion:
          recommendedMinimumVersion ?? this.recommendedMinimumVersion,
      requiredMinimumVersion:
          requiredMinimumVersion ?? this.requiredMinimumVersion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'geminiApiKey': geminiApiKey,
      'recommendedMinimumVersion': recommendedMinimumVersion,
      'requiredMinimumVersion': requiredMinimumVersion,
    };
  }

  factory RemoteConfigModel.fromMap(Map<String, dynamic> map) {
    return RemoteConfigModel(
      geminiApiKey: map['geminiApiKey'] as String,
      recommendedMinimumVersion: map['recommendedMinimumVersion'] as String,
      requiredMinimumVersion: map['requiredMinimumVersion'] as String,
    );
  }

  factory RemoteConfigModel.fromMapRemoteConfig(
      Map<String, RemoteConfigValue> map) {
    return RemoteConfigModel(
      geminiApiKey: map['geminiApiKey']?.asString() ?? '0',
      recommendedMinimumVersion:
          map['recommendedMinimumVersion']?.asString() ?? '1.0.0',
      requiredMinimumVersion:
          map['requiredMinimumVersion']?.asString() ?? '1.0.0',
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoteConfigModel.fromJson(String source) =>
      RemoteConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RemoteConfigModel(geminiApiKey: $geminiApiKey, recommendedMinimumVersion: $recommendedMinimumVersion, requiredMinimumVersion: $requiredMinimumVersion)';

  @override
  bool operator ==(covariant RemoteConfigModel other) {
    if (identical(this, other)) return true;

    return other.geminiApiKey == geminiApiKey &&
        other.recommendedMinimumVersion == recommendedMinimumVersion &&
        other.requiredMinimumVersion == requiredMinimumVersion;
  }

  @override
  int get hashCode =>
      geminiApiKey.hashCode ^
      recommendedMinimumVersion.hashCode ^
      requiredMinimumVersion.hashCode;
}
