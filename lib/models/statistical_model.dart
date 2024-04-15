import 'dart:convert';

class StatisticalModel {
  final String id;
  final String userId;
  final int income;
  final int expense;
  final DateTime createdDate;
  final DateTime updateDate;
  StatisticalModel({
    required this.id,
    required this.userId,
    required this.income,
    required this.expense,
    required this.createdDate,
    required this.updateDate,
  });

  StatisticalModel copyWith({
    String? id,
    String? userId,
    int? income,
    int? expense,
    DateTime? createdDate,
    DateTime? updateDate,
  }) {
    return StatisticalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      createdDate: createdDate ?? this.createdDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'income': income,
      'expense': expense,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
    };
  }

  factory StatisticalModel.fromMap(Map<String, dynamic> map) {
    return StatisticalModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      income: map['income'] as int,
      expense: map['expense'] as int,
      createdDate:
          DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticalModel.fromJson(String source) =>
      StatisticalModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatisticalModel(id: $id, userId: $userId, income: $income, expense: $expense, createdDate: $createdDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(covariant StatisticalModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.income == income &&
        other.expense == expense &&
        other.createdDate == createdDate &&
        other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        income.hashCode ^
        expense.hashCode ^
        createdDate.hashCode ^
        updateDate.hashCode;
  }
}
