import 'package:chiqimlarim/utilities/formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class CostScreen extends StatelessWidget {
  final String costName;

  const CostScreen({super.key, required this.costName});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final cost =
        expenseProvider.costs.firstWhere((element) => element.name == costName);

    double totalSpent =
        cost.expenses.fold(0, (sum, expense) => sum + expense.amount);

    String formatCurrency(double amount) {
      if (amount >= 1000000) {
        return '${(amount / 1000000).toStringAsFixed(0)} mln so\'m';
      } else if (amount >= 1000) {
        return '${(amount / 1000).toStringAsFixed(0)} ming so\'m';
      } else {
        return '${amount.toStringAsFixed(0)} so\'m';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(costName),
      ),
      body: Column(
        children: [
          totalSpent != 0
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Umumiy xarajat ${formatCurrency(totalSpent)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF0E4E),
                    ),
                  ),
                )
              : const SizedBox(),
          Expanded(
            child: cost.expenses.isEmpty
                ? Center(
                    child: Text('$costName uchun hali xarajat qilinmagan'),
                  )
                : ListView.builder(
                    itemCount: cost.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = cost.expenses[index];
                      return Dismissible(
                        key: Key(expense.name),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          expenseProvider.deleteExpense(
                              costName, expense.name); // Delete expense
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${expense.name} deleted')),
                          );
                        },
                        background: Container(
                          color: const Color(0xFFFF0E4E),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(left: 16.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Text(expense.name),
                          subtitle: Text(formatCurrency(expense.amount)),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () => _addExpenseDialog(context),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _addExpenseDialog(BuildContext context) {
    TextEditingController expenseNameController = TextEditingController();
    TextEditingController expenseAmountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xarajat qo\'shish'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: expenseNameController,
                decoration: const InputDecoration(labelText: 'Nomi'),
              ),
              TextField(
                controller: expenseAmountController,
                inputFormatters: [Formatter()],
                decoration: const InputDecoration(labelText: 'Qiymati'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Yopish'),
            ),
            ElevatedButton(
              onPressed: () {
                String expenseName = expenseNameController.text;
                double expenseAmount = double.parse(
                    expenseAmountController.text.replaceAll(',', ''));
                if (expenseName.isNotEmpty && expenseAmount > 0) {
                  Provider.of<ExpenseProvider>(context, listen: false)
                      .addExpense(costName, expenseName, expenseAmount);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Qo\'shish'),
            ),
          ],
        );
      },
    );
  }
}
