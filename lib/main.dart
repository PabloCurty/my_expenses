import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_expenses/components/chart.dart';
import 'package:my_expenses/components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'package:my_expenses/models/transaction.dart';

main() => runApp(const MyExpensesApp());

class MyExpensesApp extends StatelessWidget {
  const MyExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();

    return MaterialApp(
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        textTheme: tema.textTheme.copyWith(
          titleLarge: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleSmall: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final List<Transaction> _transactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'Run shoes',
    //   value: 316.76,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Light bill',
    //   value: 311.30,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't3',
    //   title: 'College bill',
    //   value: 11321.20,
    //   date: DateTime.now().subtract(const Duration(days: 2)),
    // ),
    // Transaction(
    //   id: 't4',
    //   title: 'Credcard bill',
    //   value: 355.50,
    //   date: DateTime.now().subtract(const Duration(days: 2)),
    // ),
    // Transaction(
    //   id: 't5',
    //   title: 'Medical appointment bill',
    //   value: 555.50,
    //   date: DateTime.now().subtract(const Duration(days: 1)),
    // ),
    // Transaction(
    //   id: 't6',
    //   title: 'Bill 1',
    //   value: 255.50,
    //   date: DateTime.now().subtract(const Duration(days: 1)),
    // ),
    // Transaction(
    //   id: 't7',
    //   title: 'Bill 2',
    //   value: 25.50,
    //   date: DateTime.now().subtract(const Duration(days: 3)),
    // ),
    // Transaction(
    //   id: 't8',
    //   title: 'Bill 3',
    //   value: 256.00,
    //   date: DateTime.now().subtract(const Duration(days: 4)),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: date
    );

    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Expenses'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ignore: sized_box_for_whitespace
            Chart(_recentTransactions),
            TransactionList(transactions: _transactions),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactionFormModal(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
