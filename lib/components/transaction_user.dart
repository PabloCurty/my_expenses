import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_expenses/models/transaction.dart';
import 'transaction_form.dart';
import 'transaction_list.dart';

class TransactionUser extends StatefulWidget {
  const TransactionUser({super.key});

  @override
  State<TransactionUser> createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
  static final List<Transaction> _transactions = [
    Transaction(
      id: 't1',
      title: 'Run shoes',
      value: 316.76,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Light bill',
      value: 311.30,
      date: DateTime.now(),
    ),
  ];

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: DateTime.now());

    setState(() {
      _transactions.add(newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TransactionList(transactions: _transactions),
        TransactionForm(_addTransaction),
      ],
    );
  }
}
