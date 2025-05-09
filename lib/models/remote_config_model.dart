import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigModel {
  final String geminiApiKey;
  final String recommendedMinimumVersion;
  final String requiredMinimumVersion;
  final bool isAds;

  RemoteConfigModel({
    required this.geminiApiKey,
    required this.recommendedMinimumVersion,
    required this.requiredMinimumVersion,
    required this.isAds,
  });

  RemoteConfigModel copyWith({
    String? geminiApiKey,
    String? recommendedMinimumVersion,
    String? requiredMinimumVersion,
    bool? isAds,
  }) {
    return RemoteConfigModel(
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      recommendedMinimumVersion:
          recommendedMinimumVersion ?? this.recommendedMinimumVersion,
      requiredMinimumVersion:
          requiredMinimumVersion ?? this.requiredMinimumVersion,
      isAds: isAds ?? this.isAds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'geminiApiKey': geminiApiKey,
      'recommendedMinimumVersion': recommendedMinimumVersion,
      'requiredMinimumVersion': requiredMinimumVersion,
      'isAds': isAds,
    };
  }

  factory RemoteConfigModel.fromMap(Map<String, dynamic> map) {
    return RemoteConfigModel(
      geminiApiKey: map['geminiApiKey'] as String,
      recommendedMinimumVersion: map['recommendedMinimumVersion'] as String,
      requiredMinimumVersion: map['requiredMinimumVersion'] as String,
      isAds: map['isAds'] as bool,
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
      isAds: map['isAds']?.asBool() ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoteConfigModel.fromJson(String source) =>
      RemoteConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RemoteConfigModel(geminiApiKey: $geminiApiKey, recommendedMinimumVersion: $recommendedMinimumVersion, requiredMinimumVersion: $requiredMinimumVersion, isAds: $isAds)';

  @override
  bool operator ==(covariant RemoteConfigModel other) {
    if (identical(this, other)) return true;

    return other.geminiApiKey == geminiApiKey &&
        other.recommendedMinimumVersion == recommendedMinimumVersion &&
        other.requiredMinimumVersion == requiredMinimumVersion
        && other.isAds == isAds;
  }

  @override
  int get hashCode =>
      geminiApiKey.hashCode ^
      recommendedMinimumVersion.hashCode ^
      requiredMinimumVersion.hashCode ^
      isAds.hashCode;
}
