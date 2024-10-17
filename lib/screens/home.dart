import 'package:chiqimlarim/providers/expense_provider.dart';
import 'package:chiqimlarim/screens/cost_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chiqimlarim'),
      ),
      body: expenseProvider.costs.isEmpty
          ? const Center(
              child: Text(
                'Hali xarajatlar qo\'shilmagan, yangi xarajat qo\'shish uchun + ni bosing!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: expenseProvider.costs.length,
              itemBuilder: (context, index) {
                final cost = expenseProvider.costs[index];

                final formattedDate =
                    DateFormat.yMMMMd().format(cost.createdDate);

                return Dismissible(
                  key: Key(cost.name),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    expenseProvider.deleteCost(cost.name);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('${cost.name} o\'chirib tashlandi')),
                    );
                  },
                  background: Container(
                    color: const Color(0xFFFF0E4E),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(left: 16.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(cost.name),
                    subtitle: Text(formattedDate),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CostScreen(costName: cost.name),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCostDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addCostDialog(BuildContext context) {
    TextEditingController costNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yangi xarajat qo\'shish'),
          content: TextField(
            controller: costNameController,
            decoration: const InputDecoration(labelText: 'Chiqim nomi'),
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
                String costName = costNameController.text;
                if (costName.isNotEmpty) {
                  Provider.of<ExpenseProvider>(context, listen: false)
                      .addCost(costName, 100); // This will also add the date
                }
                Navigator.of(context).pop();
              },
              child: const Text('Yaratish'),
            ),
          ],
        );
      },
    );
  }
}
