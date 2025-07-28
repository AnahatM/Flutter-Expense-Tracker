import 'package:flutter/material.dart';
import 'package:minimalist_expense_tracker/components/expense_summary.dart';
import 'package:minimalist_expense_tracker/components/expense_tile.dart';
import 'package:minimalist_expense_tracker/data/expense_data.dart';
import 'package:minimalist_expense_tracker/models/expense_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Text controllers for input fields
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  // Function to add a new expense
  void addNewExpense() {
    selectedDate = DateTime.now(); // Reset to today when opening dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add New Expense'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expense name input
                TextField(
                  controller: newExpenseNameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                // Expense amount input
                TextField(
                  controller: newExpenseAmountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                // Date picker
                SizedBox(height: 16),
                Row(
                  children: [
                    Text("Date "),
                    TextButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Text(
                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Save button
              MaterialButton(onPressed: saveNewExpense, child: Text('Save')),
              // Cancel button
              MaterialButton(
                onPressed: cancelNewExpense,
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void clearInputFields() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
    selectedDate = DateTime.now();
  }

  // Function to save the new expense
  void saveNewExpense() {
    // Read values before clearing
    String name = newExpenseNameController.text;
    String amount = newExpenseAmountController.text;
    DateTime date = selectedDate;

    clearInputFields();

    // Create a new ExpenseItem
    ExpenseItem newExpense = ExpenseItem(
      name: name,
      amount: amount,
      dateTime: date,
    );
    // Add the new expense to the ExpenseData provider
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    // Close the dialog
    Navigator.pop(context);
  }

  // Function to cancel adding a new expense
  void cancelNewExpense() {
    clearInputFields();

    // Close the dialog
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder:
          (context, value, child) => Scaffold(
            backgroundColor: Colors.grey[300],
            floatingActionButton: FloatingActionButton(
              onPressed: addNewExpense,
              child: Icon(Icons.add),
            ),
            body: ListView(
              children: [
                // Weekly summary bar graph section
                ExpenseSummary(startOfWeek: value.getStartOfWeek()),
                // Expenses list section
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getExpenseList().length,
                  itemBuilder:
                      (context, index) => ExpenseTile(
                        name: value.getExpenseList()[index].name,
                        amount: value.getExpenseList()[index].amount,
                        date: value.getExpenseList()[index].dateTime,
                      ),
                ),
              ],
            ),
          ),
    );
  }
}
