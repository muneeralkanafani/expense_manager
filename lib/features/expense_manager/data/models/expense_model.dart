import '../../domain/entites/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.amount,
    required super.categoryId,
    required super.payee,
    required super.note,
    required super.date,
    required super.tag,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      amount: json['amount'],
      categoryId: json['categoryId'],
      payee: json['payee'],
      note: json['note'],
      date: DateTime.parse(json['date']),
      tag: json['tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'categoryId': categoryId,
      'payee': payee,
      'note': note,
      'date': date.toIso8601String(),
      'tag': tag,
    };
  }

  Expense toEntity() => Expense(
    id: id,
    amount: amount,
    categoryId: categoryId,
    payee: payee,
    note: note,
    date: date,
    tag: tag,
  );

  static ExpenseModel fromEntity(Expense e) => ExpenseModel(
    id: e.id,
    amount: e.amount,
    categoryId: e.categoryId,
    payee: e.payee,
    note: e.note,
    date: e.date,
    tag: e.tag,
  );
}
