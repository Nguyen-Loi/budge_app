import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigModel {
  final String assistantApiKey;
  final String assistantModel;
  final String recommendedMinimumVersion;
  final String requiredMinimumVersion;
  final bool isAds;

  RemoteConfigModel({
    required this.assistantApiKey,
    required this.assistantModel,
    required this.recommendedMinimumVersion,
    required this.requiredMinimumVersion,
    required this.isAds,
  });

  RemoteConfigModel.empty()
      : assistantApiKey = '0',
        assistantModel = 'google/gemma-3n-e4b-it:free',
        recommendedMinimumVersion = '1.0.0',
        requiredMinimumVersion = '1.0.0',
        isAds = false;

  RemoteConfigModel copyWith({
    String? assistantApiKey,
    String? assistantModel,
    String? recommendedMinimumVersion,
    String? requiredMinimumVersion,
    bool? isAds,
  }) {
    return RemoteConfigModel(
      assistantApiKey: assistantApiKey ?? this.assistantApiKey,
      assistantModel: assistantModel ?? this.assistantModel,
      recommendedMinimumVersion:
          recommendedMinimumVersion ?? this.recommendedMinimumVersion,
      requiredMinimumVersion:
          requiredMinimumVersion ?? this.requiredMinimumVersion,
      isAds: isAds ?? this.isAds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'assistantApiKey': assistantApiKey,
      'assistantModel': assistantModel,
      'recommendedMinimumVersion': recommendedMinimumVersion,
      'requiredMinimumVersion': requiredMinimumVersion,
      'isAds': isAds,
    };
  }

  factory RemoteConfigModel.fromMap(Map<String, dynamic> map) {
    return RemoteConfigModel(
      assistantApiKey: map['assistantApiKey'] as String,
      assistantModel: map['assistantModel'] as String,
      recommendedMinimumVersion: map['recommendedMinimumVersion'] as String,
      requiredMinimumVersion: map['requiredMinimumVersion'] as String,
      isAds: map['isAds'] as bool,
    );
  }

  factory RemoteConfigModel.fromMapRemoteConfig(
      Map<String, RemoteConfigValue> map) {
    return RemoteConfigModel(
      assistantApiKey: map['assistantApiKey']?.asString() ?? '0',
      assistantModel:
          map['assistantModel']?.asString() ?? 'google/gemma-3n-e4b-it:free',
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
      'RemoteConfigModel(assistantApiKey: $assistantApiKey, assistantModel: $assistantModel, recommendedMinimumVersion: $recommendedMinimumVersion, requiredMinimumVersion: $requiredMinimumVersion, isAds: $isAds)';

  @override
  bool operator ==(covariant RemoteConfigModel other) {
    if (identical(this, other)) return true;

    return other.assistantApiKey == assistantApiKey &&
        other.assistantModel == assistantModel &&
        other.recommendedMinimumVersion == recommendedMinimumVersion &&
        other.requiredMinimumVersion == requiredMinimumVersion &&
        other.isAds == isAds;
  }

  @override
  int get hashCode =>
      assistantApiKey.hashCode ^
      assistantModel.hashCode ^
      recommendedMinimumVersion.hashCode ^
      requiredMinimumVersion.hashCode ^
      isAds.hashCode;
}
