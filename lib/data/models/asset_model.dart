import 'dart:convert';

import 'package:budget_app/core/enums/asset_type_enum.dart';

class AssetModel {
  final String id;
  final String name;
  final String url;
  final String? description;
  final int? index;
  final AssetTypeEnum assetType;
  final DateTime createdDate;
  final DateTime updatedDate;
  AssetModel({
    required this.id,
    required this.name,
    required this.url,
    this.description,
    this.index,
    required this.assetType,
    required this.createdDate,
    required this.updatedDate,
  });

  AssetModel copyWith({
    String? id,
    String? name,
    String? url,
    String? description,
    int? index,
    AssetTypeEnum? assetType,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return AssetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      description: description ?? this.description,
      index: index ?? this.index,
      assetType: assetType ?? this.assetType,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'url': url,
      'description': description,
      'index': index,
      'assetType': assetType.code,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
  }

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      id: map['id'] as String,
      name: map['name'] as String,
      url: map['url'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      index: map['index'] != null ? map['index'] as int : null,
      assetType: AssetTypeEnum.fromCode(map['assetType'] as String),
      createdDate:
          DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate:
          DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetModel.fromJson(String source) =>
      AssetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PhotoModel(id: $id, name: $name, url: $url, description: $description, index: $index, assetType: $assetType, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant AssetModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.url == url &&
        other.description == description &&
        other.index == index &&
        other.assetType == assetType &&
        other.createdDate == createdDate &&
        other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        url.hashCode ^
        description.hashCode ^
        index.hashCode ^
        assetType.hashCode ^
        createdDate.hashCode ^
        updatedDate.hashCode;
  }
}
