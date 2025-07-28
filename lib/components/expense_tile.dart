import 'package:flutter/material.dart';
import 'package:minimalist_expense_tracker/datetime/date_time_utils.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime date;

  const ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(formatDateTimeDisplay(date)),
      trailing: Text("\$$amount"),
    );
  }
}
