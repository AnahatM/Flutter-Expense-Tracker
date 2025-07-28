import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimalist_expense_tracker/data/expense_data.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Open a Hive box
  await Hive.openBox('expense_database');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      builder:
          (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
    );
  }
}
