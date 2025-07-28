import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:minimalist_expense_tracker/datetime/date_time_utils.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime date;
  final void Function(BuildContext context) deleteTapped;
  final void Function(BuildContext context) editTapped;

  const ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.date,
    required this.deleteTapped,
    required this.editTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // Delete Button
          SlidableAction(
            onPressed: deleteTapped,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),

          // Edit Button
          SlidableAction(
            onPressed: editTapped,
            icon: Icons.edit,
            backgroundColor: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 4, bottom: 4),
        child: ListTile(
          title: Text(name),
          subtitle: Text(formatDateTimeDisplay(date)),
          trailing: Text(
            "\$$amount",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          tileColor: Colors.grey[200],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
