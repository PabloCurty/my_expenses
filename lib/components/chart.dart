// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:my_expenses/components/chart_bar.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  const Chart(this.recentTransactions, {super.key});

  final List<Transaction> recentTransactions;

  List<Map<String, dynamic>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      String firstWordWeekDay = DateFormat.E().format(weekDay)[0];
      for (var recentTransaction in recentTransactions) {
        bool sameDay = recentTransaction.date.day == weekDay.day;
        bool sameMonth = recentTransaction.date.month == weekDay.month;
        bool sameYear = recentTransaction.date.year == weekDay.year;
        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction.value;
        }
      }
      print(firstWordWeekDay);
      print(totalSum);
      return {'day': firstWordWeekDay, 'value': totalSum};
    });
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + tr['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'].toString(),
                value: tr['value'],
                percentage: tr['value'] / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
