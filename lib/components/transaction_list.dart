import 'package:flutter/material.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: transactions.isEmpty
          ? Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  'No transactions!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                final e = transactions[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            'R\$${e.value}',
                             style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      e.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      DateFormat('d MMM y').format(e.date),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
