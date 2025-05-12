// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IosDeviceModel {
  final String systemName;
  final String? identifierForVendor;
  IosDeviceModel({
    required this.systemName,
    this.identifierForVendor,
  });

  IosDeviceModel copyWith({
    String? systemName,
    String? identifierForVendor,
  }) {
    return IosDeviceModel(
      systemName: systemName ?? this.systemName,
      identifierForVendor: identifierForVendor ?? this.identifierForVendor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'systemName': systemName,
      'identifierForVendor': identifierForVendor,
    };
  }

  factory IosDeviceModel.fromMap(Map<String, dynamic> map) {
    return IosDeviceModel(
      systemName: map['systemName'] as String,
      identifierForVendor: map['identifierForVendor'] != null ? map['identifierForVendor'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IosDeviceModel.fromJson(String source) => IosDeviceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'IosDeviceModel(systemName: $systemName, identifierForVendor: $identifierForVendor)';

  @override
  bool operator ==(covariant IosDeviceModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.systemName == systemName &&
      other.identifierForVendor == identifierForVendor;
  }

  @override
  int get hashCode => systemName.hashCode ^ identifierForVendor.hashCode;
}
