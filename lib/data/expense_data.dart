import 'package:flutter/material.dart';
import 'package:minimalist_expense_tracker/data/hive_database.dart';
import 'package:minimalist_expense_tracker/datetime/date_time_utils.dart';
import 'package:minimalist_expense_tracker/models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  // List of all expenses
  List<ExpenseItem> overallExpenseList = [];

  // Get expense list
  List<ExpenseItem> getExpenseList() => overallExpenseList;

  // Prepare data to display
  final db = HiveDataBase();
  void prepareData() {
    // Retrieve data from Hive if it exists
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // Add an expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // Delete an expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // Edit an expense
  void editExpense(ExpenseItem oldExpense, ExpenseItem newExpense) {
    int index = overallExpenseList.indexOf(oldExpense);
    if (index != -1) {
      overallExpenseList[index] = newExpense;
      notifyListeners();
      db.saveData(overallExpenseList);
    }
  }

  // Get weekday name from dateTime
  String getWeekdayFromDate(DateTime date) {
    return switch (date.weekday) {
      1 => 'Mon',
      2 => 'Tue',
      3 => 'Wed',
      4 => 'Thu',
      5 => 'Fri',
      6 => 'Sat',
      7 => 'Sun',
      _ => '',
    };
  }

  // Get date for start of the week on Sunday
  DateTime getStartOfWeek() {
    DateTime? startOfWeek;
    // Get today's date
    DateTime today = DateTime.now();
    // Go backwards to find the previous Sunday
    for (int i = 0; i < 7; i++) {
      if (getWeekdayFromDate(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
        break;
      }
    }
    return startOfWeek!;
  }

  // Convert overall list of expenses into a daily expense summary
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // Date in 'yyyy-MM-dd' format : total amount for that day
    };

    for (var expense in overallExpenseList) {
      String dateKey = convertDateTimeToString(expense.dateTime);
      double amount = double.tryParse(expense.amount) ?? 0.0;

      if (dailyExpenseSummary.containsKey(dateKey)) {
        // If the date already exists, add the amount to the existing total
        dailyExpenseSummary[dateKey] = dailyExpenseSummary[dateKey]! + amount;
      } else {
        // If the date does not exist, create a new entry
        dailyExpenseSummary.addAll({dateKey: amount});
      }
    }

    return dailyExpenseSummary;
  }
}
