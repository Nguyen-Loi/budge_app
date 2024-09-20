// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AndroidDeviceModel {
  final String brand;
  final String model;
  final int sdkVersion;

  AndroidDeviceModel({
    required this.brand,
    required this.model,
    required this.sdkVersion,
  });

  AndroidDeviceModel copyWith({
    String? brand,
    String? model,
    int? sdkVersion,
  }) {
    return AndroidDeviceModel(
      brand: brand ?? this.brand,
      model: model ?? this.model,
      sdkVersion: sdkVersion ?? this.sdkVersion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'brand': brand,
      'model': model,
      'sdkVersion': sdkVersion,
    };
  }

  factory AndroidDeviceModel.fromMap(Map<String, dynamic> map) {
    return AndroidDeviceModel(
      brand: map['brand'] as String,
      model: map['model'] as String,
      sdkVersion: map['sdkVersion'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AndroidDeviceModel.fromJson(String source) => AndroidDeviceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AndroidDeviceModel(brand: $brand, model: $model, sdkVersion: $sdkVersion)';

  @override
  bool operator ==(covariant AndroidDeviceModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.brand == brand &&
      other.model == model &&
      other.sdkVersion == sdkVersion;
  }

  @override
  int get hashCode => brand.hashCode ^ model.hashCode ^ sdkVersion.hashCode;
}
