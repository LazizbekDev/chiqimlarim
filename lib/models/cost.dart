import 'package:chiqimlarim/models/expense_model.dart';

class Cost {
  String name;
  double totalDeposit;
  List<Expense> expenses;
  final DateTime createdDate;

  Cost({
    required this.name,
    required this.totalDeposit,
    required this.expenses,
    required this.createdDate,
  });

  // Convert Cost object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalDeposit': totalDeposit,
      'expenses': expenses.map((e) => e.toJson()).toList(),
      'createdDate':
          createdDate.toIso8601String(), // Convert DateTime to string
    };
  }

  factory Cost.fromJson(Map<String, dynamic> json) {
    return Cost(
      name: json['name'],
      totalDeposit: json['totalDeposit'],
      expenses:
          (json['expenses'] as List).map((e) => Expense.fromJson(e)).toList(),
      createdDate: json['createdDate'] != null
          ? DateTime.parse(
              json['createdDate']) // Convert string to DateTime if not null
          : DateTime.now(), // Use current date if `createdDate` is null
    );
  }
}
