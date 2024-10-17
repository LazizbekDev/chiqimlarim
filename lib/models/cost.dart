import 'package:chiqimlarim/models/expense_model.dart';

class Cost {
  String name;
  double totalDeposit;
  List<Expense> expenses;

  Cost({required this.name, required this.totalDeposit, required this.expenses});

  // Convert Cost object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalDeposit': totalDeposit,
      'expenses': expenses.map((expense) => expense.toJson()).toList(),
    };
  }

  // Create a Cost object from JSON
  static Cost fromJson(Map<String, dynamic> json) {
    return Cost(
      name: json['name'],
      totalDeposit: json['totalDeposit'],
      expenses: (json['expenses'] as List)
          .map((expenseJson) => Expense.fromJson(expenseJson))
          .toList(),
    );
  }
}
