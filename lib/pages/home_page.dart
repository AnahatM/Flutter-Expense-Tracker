import 'package:flutter/material.dart';
import 'package:minimalist_expense_tracker/components/date_picker_button.dart';
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
  final newExpenseDollarsController = TextEditingController();
  final newExpenseCentsController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Prepare data when the page is initialized
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // Function to clear input fields
  void clearInputFields() {
    newExpenseNameController.clear();
    newExpenseDollarsController.clear();
    newExpenseCentsController.clear();
    selectedDate = DateTime.now();
  }

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
                  decoration: const InputDecoration(hintText: 'Expense Name'),
                ),
                // Expense amount input
                Row(
                  children: [
                    // Dollars
                    Expanded(
                      child: TextField(
                        controller: newExpenseDollarsController,
                        decoration: const InputDecoration(hintText: 'Dollars'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    // Cents
                    Expanded(
                      child: TextField(
                        controller: newExpenseCentsController,
                        decoration: const InputDecoration(hintText: 'Cents'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Date picker
                DatePickerButton(
                  selectedDate: selectedDate,
                  onDateChanged: (picked) {
                    setState(() {
                      selectedDate = picked;
                    });
                  },
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

  // Function to handle editing an expense
  void editExpense(ExpenseItem expense) {
    newExpenseNameController.text = expense.name;
    // Split amount into dollars and cents safely
    List<String> amountParts = expense.amount.split('.');
    newExpenseDollarsController.text = amountParts[0];
    newExpenseCentsController.text =
        amountParts.length > 1 ? amountParts[1] : '00';
    selectedDate = expense.dateTime;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Expense'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expense name input
                TextField(
                  controller: newExpenseNameController,
                  decoration: const InputDecoration(hintText: 'Expense Name'),
                ),
                // Expense amount input
                Row(
                  children: [
                    // Dollars
                    Expanded(
                      child: TextField(
                        controller: newExpenseDollarsController,
                        decoration: const InputDecoration(hintText: 'Dollars'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    // Cents
                    Expanded(
                      child: TextField(
                        controller: newExpenseCentsController,
                        decoration: const InputDecoration(hintText: 'Cents'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Date picker
                DatePickerButton(
                  selectedDate: selectedDate,
                  onDateChanged: (picked) {
                    setState(() {
                      selectedDate = picked;
                    });
                  },
                ),
              ],
            ),
            actions: [
              // Confirm button now calls saveEditedExpense
              MaterialButton(
                onPressed: () => saveEditedExpense(expense),
                child: Text('Confirm'),
              ),
              // Cancel button
              MaterialButton(
                onPressed: cancelNewExpense,
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  // Function to save the new expense
  // Function to save the edited expense
  void saveEditedExpense(ExpenseItem oldExpense) {
    // Read values before clearing
    String name = newExpenseNameController.text.trim();
    String dollars = newExpenseDollarsController.text.trim();
    String cents = newExpenseCentsController.text.trim();
    DateTime date = selectedDate;

    // Validate fields
    if (name.isEmpty || dollars.isEmpty || cents.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all fields.')));
      return;
    }

    clearInputFields();

    // Create a new ExpenseItem
    ExpenseItem newExpense = ExpenseItem(
      name: name,
      amount: '$dollars.$cents',
      dateTime: date,
    );
    // Edit the expense in the ExpenseData provider
    Provider.of<ExpenseData>(
      context,
      listen: false,
    ).editExpense(oldExpense, newExpense);

    // Close the dialog
    Navigator.pop(context);
  }

  void saveNewExpense() {
    // Read values before clearing
    String name = newExpenseNameController.text.trim();
    String dollars = newExpenseDollarsController.text.trim();
    String cents = newExpenseCentsController.text.trim();
    DateTime date = selectedDate;

    // Validate fields
    if (name.isEmpty || dollars.isEmpty || cents.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all fields.')));
      return;
    }

    clearInputFields();

    // Create a new ExpenseItem
    ExpenseItem newExpense = ExpenseItem(
      name: name,
      amount: '$dollars.$cents',
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

  // Function to delete an expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder:
          (context, value, child) => Scaffold(
            backgroundColor: Colors.grey[300],
            floatingActionButton: FloatingActionButton(
              onPressed: addNewExpense,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              tooltip: 'Add Expense',
              shape: CircleBorder(),
              child: Icon(Icons.add),
            ),
            body: ListView(
              children: [
                const SizedBox(height: 20),

                // Weekly summary bar graph section
                ExpenseSummary(startOfWeek: value.getStartOfWeek()),

                const SizedBox(height: 20),

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
                        deleteTapped:
                            (context) =>
                                deleteExpense(value.getExpenseList()[index]),
                        editTapped:
                            (context) =>
                                editExpense(value.getExpenseList()[index]),
                      ),
                ),
              ],
            ),
          ),
    );
  }
}
