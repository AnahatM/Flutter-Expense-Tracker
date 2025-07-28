import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimalist_expense_tracker/models/expense_item.dart';

class HiveDataBase {
  // Reference box
  final _myBox = Hive.box('expense_database');

  // Write data
  void saveData(List<ExpenseItem> allExpenses) {
    /*
    Hive only stores primitive data types, cannot store custom objects like ExpenseItem directly.
    So convert ExpenseItem objects into types that can be stored in Hive.
    */

    List<List<dynamic>> alLExpensesFormatted = [];

    for (var expense in allExpenses) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      alLExpensesFormatted.add(expenseFormatted);
    }

    // Save the formatted data to Hive
    _myBox.put('ALL_EXPENSES', alLExpensesFormatted);
  }

  // Read data
  List<ExpenseItem> readData() {
    /*
    Data is stored in Hive as a list of strings and date times.
    Read the data from Hive and convert it back to ExpenseItem objects.
    */

    List<dynamic> allExpensesFormatted = _myBox.get('ALL_EXPENSES') ?? [];
    List<ExpenseItem> allExpenses = [];

    for (var expense in allExpensesFormatted) {
      // Create and add ExpenseItem object to the list
      allExpenses.add(
        ExpenseItem(name: expense[0], amount: expense[1], dateTime: expense[2]),
      );
    }

    return allExpenses;
  }
}
