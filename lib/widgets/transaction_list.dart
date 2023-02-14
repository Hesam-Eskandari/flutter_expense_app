import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'dart:math';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function _deleteTransaction;

  TransactionList(this._transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return _transactions.isEmpty ?
        LayoutBuilder(builder: (ctx, constraints){
          return Column(
            children: <Widget>[
              Container(
                height: constraints.maxHeight * 0.05,
                child: FittedBox(
                  child: Text(
                    'No transaction added yet!',
                    style: theme.textTheme.titleMedium,
                  ), // Text
                ), // FittedBox
              ), // Container
              SizedBox(height: constraints.maxHeight * 0.15),
              Container(
                height: constraints.maxHeight * 0.8,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                ), // Image
              ), // Container
            ],
          );
        }) : ListView.builder(
            itemBuilder: (ctx, index) {
              var tx = _transactions[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal:5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 32,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: FittedBox(
                        child: Text('\$${tx.amount}'),
                      ), // FittedBox
                    ), // Padding
                  ), // CircleAvatar
                  title: Text(
                    tx.title,
                    style: theme.textTheme.titleLarge,
                  ),
                  subtitle: Text('${DateFormat.yMMMEd().format(tx.date)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: theme.errorColor,
                    onPressed: () => _deleteTransaction(tx)
                  ),
                ), // ListTile
              ); // Card
            },
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
              itemCount: _transactions.length,


    );
  }
}
