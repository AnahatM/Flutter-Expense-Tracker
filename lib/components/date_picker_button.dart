import 'package:flutter/material.dart';

class DatePickerButton extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DatePickerButton({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
              onDateChanged(picked);
            }
          },
          child: Text(
            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
