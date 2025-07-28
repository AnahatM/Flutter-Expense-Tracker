import 'package:flutter/material.dart';
import 'package:minimalist_expense_tracker/bar_graph/bar_graph.dart';
import 'package:minimalist_expense_tracker/data/expense_data.dart';
import 'package:minimalist_expense_tracker/datetime/date_time_utils.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;

  const ExpenseSummary({super.key, required this.startOfWeek});

  // Calculate week total
  String calculateWeekTotal(List<double> weekAmounts) {
    return weekAmounts.reduce((a, b) => a + b).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // Get yyyymmdd format for each day of the week
    String sunday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 0)),
    );
    String monday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 1)),
    );
    String tuesday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 2)),
    );
    String wednesday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 3)),
    );
    String thursday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 4)),
    );
    String friday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 5)),
    );
    String saturday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 6)),
    );

    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        final dailySummary = value.calculateDailyExpenseSummary();
        final weekAmounts = [
          dailySummary[sunday] ?? 0,
          dailySummary[monday] ?? 0,
          dailySummary[tuesday] ?? 0,
          dailySummary[wednesday] ?? 0,
          dailySummary[thursday] ?? 0,
          dailySummary[friday] ?? 0,
          dailySummary[saturday] ?? 0,
        ];

        // Find the max expense for the week, set a minimum for visibility
        final maxY = weekAmounts.reduce((a, b) => a > b ? a : b);
        final displayMaxY = maxY < 100 ? 100 : maxY;

        return Column(
          children: [
            // Week total
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Text("Week total: ", style: TextStyle(fontSize: 18)),
                  Text(
                    "\$${calculateWeekTotal(weekAmounts)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Bar graph to show weekly expenses
            SizedBox(
              height: 250,
              child: BarGraph(
                maxY: displayMaxY.toDouble() * 1.1,
                sunAmount: weekAmounts[0],
                monAmount: weekAmounts[1],
                tueAmount: weekAmounts[2],
                wedAmount: weekAmounts[3],
                thuAmount: weekAmounts[4],
                friAmount: weekAmounts[5],
                satAmount: weekAmounts[6],
              ),
            ),
          ],
        );
      },
    );
  }
}
