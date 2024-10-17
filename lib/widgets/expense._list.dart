import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpenseProvider>(context).costs;

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(expenses[index].name),
        );
      },
    );
  }
}
