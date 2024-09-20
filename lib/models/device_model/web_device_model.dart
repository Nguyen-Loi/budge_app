// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WebDeviceModel {
  final String browserName;
  final String? userAgent;
  WebDeviceModel({
    required this.browserName,
    this.userAgent,
  });

 

  WebDeviceModel copyWith({
    String? browserName,
    String? userAgent,
  }) {
    return WebDeviceModel(
      browserName: browserName ?? this.browserName,
      userAgent: userAgent ?? this.userAgent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'browserName': browserName,
      'userAgent': userAgent,
    };
  }

  factory WebDeviceModel.fromMap(Map<String, dynamic> map) {
    return WebDeviceModel(
      browserName: map['browserName'] as String,
      userAgent: map['userAgent'] != null ? map['userAgent'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WebDeviceModel.fromJson(String source) => WebDeviceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WebDeviceModel(browserName: $browserName, userAgent: $userAgent)';

  @override
  bool operator ==(covariant WebDeviceModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.browserName == browserName &&
      other.userAgent == userAgent;
  }

  @override
  int get hashCode => browserName.hashCode ^ userAgent.hashCode;
}
