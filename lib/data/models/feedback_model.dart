import 'dart:convert';

class FeedbackModel {
  final String id;
  final String userId;
  final String title;
  final String content;
  final int rating; // 1-5 stars
  final String? userEmail;
  final String? userName;
  final DateTime createdDate;
  final DateTime updatedDate;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.rating,
    this.userEmail,
    this.userName,
    required this.createdDate,
    required this.updatedDate,
  });

  FeedbackModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    int? rating,
    String? userEmail,
    String? userName,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'rating': rating,
      'userEmail': userEmail,
      'userName': userName,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      rating: map['rating'] as int,
      userEmail: map['userEmail'] != null ? map['userEmail'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updatedDate: DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedbackModel.fromJson(String source) =>
      FeedbackModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FeedbackModel(id: $id, userId: $userId, title: $title, content: $content, rating: $rating, userEmail: $userEmail, userName: $userName, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant FeedbackModel other) {
    if (identical(this, other)) return true;
  
    return other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.content == content &&
        other.rating == rating &&
        other.userEmail == userEmail &&
        other.userName == userName &&
        other.createdDate == createdDate &&
        other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        content.hashCode ^
        rating.hashCode ^
        userEmail.hashCode ^
        userName.hashCode ^
        createdDate.hashCode ^
        updatedDate.hashCode;
  }
}