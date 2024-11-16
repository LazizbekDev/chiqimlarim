import 'package:chiqimlarim/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../providers/expense_provider.dart';

class CostScreen extends StatelessWidget {
  final String costName;

  const CostScreen({super.key, required this.costName});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final cost =
        expenseProvider.costs.firstWhere((element) => element.name == costName);

    double totalSpent = cost.expenses.fold(
        0, (sum, expense) => sum + expense.amount * (expense.multiple ?? 1));

    String formatCurrency(double amount) {
      final NumberFormat numberFormat = NumberFormat('#,##0');

      if (amount >= 1000000) {
        return '${numberFormat.format(amount / 1000000)} mln so\'m';
      } else if (amount >= 1000) {
        return '${numberFormat.format(amount)} so\'m';
      } else {
        return '${numberFormat.format(amount)} so\'m';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          costName.toUpperCase(),
          style: GoogleFonts.inter(
            color: accentColor,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leadingWidth: 35,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: accentColor,
          ),
        ),
      ),
      body: Column(
        children: [
          if (totalSpent != 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () => _divideDialog(context, totalSpent),
                child: Column(
                  children: [
                    Text(
                      'Umumiy xarajat ${formatCurrency(totalSpent)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    Consumer<ExpenseProvider>(
                      builder: (context, expenseProvider, child) {
                        double dividedAmount = expenseProvider.dividedAmount;

                        if (dividedAmount > 0) {
                          return Text(
                            'har bir kishi uchun ${formatCurrency(dividedAmount)}dan',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                          );
                        } else {
                          return Text(
                            'Xarajatlarni bo\'lish uchun bosing',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: cost.expenses.isEmpty
                ? Center(
                    child: Text(
                      '$costName uchun hali xarajat qilinmagan',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: cost.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = cost.expenses[index];
                      return Column(
                        children: [
                          Dismissible(
                            key: Key(expense.name),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              Vibration.vibrate(pattern: [200, 200]);

                              expenseProvider.deleteExpense(
                                costName,
                                expense.name,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${expense.name} yo\'q qilindi!'),
                                ),
                              );
                            },
                            background: Container(
                              color: error,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ListTile(
                              title: Text(expense.name),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatCurrency(
                                      expense.amount *
                                          double.parse(
                                            expense.multiple.toString(),
                                          ),
                                    ),
                                  ),
                                  if (expense.multiple != 1)
                                    Text(
                                      '${expense.multiple} x ${formatCurrency(expense.amount)}',
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () => _addExpenseDialog(context),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.add,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addExpenseDialog(BuildContext context) {
    TextEditingController expenseNameController = TextEditingController();
    TextEditingController expenseAmountController = TextEditingController();
    TextEditingController expenseMultipleController = TextEditingController(
      text: '1',
    );

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
                decoration: const InputDecoration(labelText: 'Qiymati'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: expenseMultipleController,
                decoration: const InputDecoration(
                    labelText: 'Ko\'paytirish', hintText: 'ixtiyoriy'),
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
                int expenseMembers = expenseMultipleController.text.isEmpty
                    ? 1
                    : int.tryParse(expenseMultipleController.text) ?? 1;

                double expenseAmount = double.parse(
                    expenseAmountController.text.replaceAll(',', ''));
                if (expenseName.isNotEmpty &&
                    expenseAmount > 0 &&
                    expenseMembers > 0) {
                  Provider.of<ExpenseProvider>(context, listen: false)
                      .addExpense(
                    costName,
                    expenseName,
                    expenseAmount,
                    expenseMembers,
                  );
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

  Future<void> _divideDialog(BuildContext context, double totalSpent) async {
    TextEditingController expenseDivideController = TextEditingController(
      text: '1',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xarajatni bo\'lish'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: expenseDivideController,
                decoration:
                    const InputDecoration(labelText: 'Nechiga bo\'lmoqchisiz?'),
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
                int divideBy = int.tryParse(expenseDivideController.text) ?? 1;
                double dividedAmount = totalSpent / divideBy;

                // Save to Provider
                Provider.of<ExpenseProvider>(context, listen: false)
                    .updateDividedAmount(dividedAmount);

                Navigator.of(context).pop();
              },
              child: const Text('Bo\'lish'),
            ),
          ],
        );
      },
    );
  }
}
