import 'package:chiqimlarim/providers/expense_provider.dart';
import 'package:chiqimlarim/screens/cost_screen.dart';
import 'package:chiqimlarim/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chiqimlarim',
          style: GoogleFonts.inter(
            color: accentColor,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        backgroundColor: Theme.of(context)
            .colorScheme
            .primary, // Primary color for the app bar
      ),
      body: expenseProvider.costs.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Hali xarajatlar qo\'shilmagan, yangi xarajat qo\'shish uchun + ni bosing!',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              itemCount: expenseProvider.costs.length,
              itemBuilder: (context, index) {
                final cost = expenseProvider.costs[index];

                final formattedDate =
                    DateFormat.yMMMMd().format(cost.createdDate);

                return Column(
                  children: [
                    Dismissible(
                      key: Key(cost.name),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        Vibration.vibrate(pattern: [200, 200]);
                        expenseProvider.deleteCost(cost.name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${cost.name} o\'chirib tashlandi'),
                          ),
                        );
                      },
                      background: Container(
                        color: Theme.of(context).colorScheme.error,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(cost.name),
                        subtitle: Text(formattedDate),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CostScreen(costName: cost.name),
                            ),
                          );
                        },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCostDialog(context),
        backgroundColor:
            Theme.of(context).colorScheme.primary, // Primary color for FAB
        child: const Icon(
          Icons.add,
          color: accentColor,
        ),
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
