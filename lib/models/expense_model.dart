class Expense {
  String name;
  double amount;

  Expense({required this.name, required this.amount});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }

  static Expense fromJson(Map<String, dynamic> json) {
    return Expense(
      name: json['name'],
      amount: json['amount'],
    );
  }
}
