import 'package:flutter/material.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XPenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(titleTextStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 20, fontWeight: FontWeight.bold)),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(context: ctx, builder: (bCtx) {
      return GestureDetector(
        onTap: () {},
        child: NewTransaction(_addNewTransaction),
        behavior: HitTestBehavior.opaque,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
        title: Text('XPenses'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context),),
        ]
    );
    final availableHeight = mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top;
    final double chartHeight = max(availableHeight * 0.24, 140);
    final double txListHeight = availableHeight - chartHeight;
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: chartHeight,
                  child: Chart(_recentTransactions),
                ),
                Container(
                height: txListHeight,
                child: TransactionList(_userTransactions, _deleteTransaction),
                ),
              ]
          )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context),),
    );
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime dateTime) {
    final newTx = Transaction(title: title, amount: amount, date: dateTime == null ? DateTime.now() : dateTime, id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(Transaction tx) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == tx.id);
    });
  }
}
