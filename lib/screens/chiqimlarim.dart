import 'package:chiqimlarim/providers/expense_provider.dart';
import 'package:chiqimlarim/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chiqimlarim extends StatelessWidget {
  const Chiqimlarim({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Monitoring',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home(),
      ),
    );
  }
}
