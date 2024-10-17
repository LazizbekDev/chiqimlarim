import 'dart:convert';
import 'package:chiqimlarim/models/cost.dart';
import 'package:chiqimlarim/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseProvider with ChangeNotifier {
  List<Cost> _costs = [];

  List<Cost> get costs => _costs;

  ExpenseProvider() {
    _loadData();
  }

  // Add a cost
  void addCost(String name, double totalDeposit) {
    final newCost = Cost(
      name: name,
      totalDeposit: totalDeposit,
      expenses: [],
      createdDate: DateTime.now(), // Provide the current date
    );
    costs.add(newCost);
    notifyListeners();
  }

  // Add an expense to a cost
  void addExpense(String costName, String expenseName, double amount) {
    final cost = _costs.firstWhere((c) => c.name == costName);
    cost.expenses.add(Expense(name: expenseName, amount: amount));
    _saveData();
    notifyListeners();
  }

  // Save data to shared preferences
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> costJson =
        _costs.map((cost) => jsonEncode(cost.toJson())).toList();
    prefs.setStringList('costs', costJson);
  }

  // Delete cost by name
  void deleteCost(String costName) {
    costs.removeWhere((cost) => cost.name == costName);
    notifyListeners();
  }

  List<Expense> getExpensesForCost(String costName) {
    return costs.firstWhere((cost) => cost.name == costName).expenses;
  }

  // Delete expense by name
  void deleteExpense(String costName, String expenseName) {
    final cost = costs.firstWhere((cost) => cost.name == costName);
    cost.expenses.removeWhere((expense) => expense.name == expenseName);
    notifyListeners();
  }

  // Load data from shared preferences
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? costJson = prefs.getStringList('costs');
    if (costJson != null) {
      _costs = costJson.map((cost) => Cost.fromJson(jsonDecode(cost))).toList();
      notifyListeners();
    }
  }
}
