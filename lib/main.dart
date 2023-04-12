import 'dart:math';
import 'dart:io';

import 'package:flutter/cupertino.dart';
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
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
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
  bool _showChart = false;
  static final List<Transaction> _transactions = [
    Transaction(
      id: 't1',
      title: 'Run shoes',
      value: 316.76,
      date: DateTime.now(),
      expenseCategory: 'clothes',
    ),
    Transaction(
      id: 't2',
      title: 'Light bill',
      value: 311.30,
      date: DateTime.now(),
      expenseCategory: 'home',
    ),
    Transaction(
      id: 't3',
      title: 'College bill',
      value: 1321.20,
      date: DateTime.now().subtract(const Duration(days: 2)),
      expenseCategory: 'education',
    ),
    Transaction(
      id: 't4',
      title: 'Credcard bill',
      value: 355.50,
      date: DateTime.now().subtract(const Duration(days: 2)),
      expenseCategory: 'creditCard',
    ),
    Transaction(
      id: 't5',
      title: 'Medical appointment bill',
      value: 555.50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      expenseCategory: 'helth',
    ),
    Transaction(
      id: 't6',
      title: 'Bill 1',
      value: 255.50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      expenseCategory: 'food',
    ),
    Transaction(
      id: 't7',
      title: 'Bill 2',
      value: 25.50,
      date: DateTime.now().subtract(const Duration(days: 3)),
      expenseCategory: 'food',
    ),
    Transaction(
      id: 't8',
      title: 'Bill 3',
      value: 256.00,
      date: DateTime.now().subtract(const Duration(days: 4)),
      expenseCategory: 'helth',
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _addTransaction(
      String title, double value, DateTime date, String expCategory) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
      expenseCategory: expCategory,
    );
    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(icon),
          )
        : IconButton(
            onPressed: fn,
            icon: Icon(icon),
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    bool isLandScape = mediaQuery.orientation == Orientation.landscape;

    final actions = <Widget>[
      if (isLandScape)
        _getIconButton(
          _showChart ? Icons.list : Icons.show_chart,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          } 
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      ),
    ];

    final appBar = AppBar(
      title: const Text('Personal Expenses'),
      actions: actions,
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // if (isLandScape)
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       const Text('Display graph'),
          //       Switch.adaptive(
          //         activeColor: Theme.of(context).colorScheme.secondary,
          //         value: _showChart,
          //         onChanged: (value) {
          //           setState(() {
          //             _showChart = value;
          //           });
          //         },
          //       ),
          //     ],
          //   ),
          if (_showChart || !isLandScape)
            SizedBox(
                height: availableHeight * (isLandScape ? 0.83 : 0.27),
                child: Chart(_recentTransactions)),
          if (!_showChart || !isLandScape)
            SizedBox(
                height: availableHeight * (isLandScape ? 1 : 0.73),
                child: TransactionList(
                    transactions: _transactions, onRemove: _removeTransaction)),
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Personal Expenses'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openTransactionFormModal(context),
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
