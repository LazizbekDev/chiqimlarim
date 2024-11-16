class Expense {
  String name;
  double amount;
  int? multiple;
  int? divide;

  Expense({required this.name, required this.amount, this.multiple = 1, this.divide = 1});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'multiple': multiple,
    };
  }

  static Expense fromJson(Map<String, dynamic> json) {
    return Expense(
      name: json['name'],
      amount: json['amount'],
      multiple: json['multiple'],
    );
  }
}
