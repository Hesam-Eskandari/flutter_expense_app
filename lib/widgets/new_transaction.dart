import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {

  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(double.parse(_amountController.text).toStringAsFixed(2));
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }
    widget.addTransaction(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now()
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
        child: Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: mediaQuery.viewInsets.bottom + 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                      onSubmitted: (_) => _submitData(),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Amount'),
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onSubmitted: (_) => _submitData(),
                    ),
                    Container(
                      height: 70,
                      child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(_selectedDate == null ? 'No Date Chosen!' : DateFormat.yMd().format(_selectedDate)),
                            ),
                            OutlinedButton(
                              child: Text('Select Date'),
                              onPressed: _presentDatePicker,
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(theme.primaryColorDark),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ]
                      ),
                    ),
                    OutlinedButton(
                      child: Text('Add Transaction'),
                      onPressed: _submitData,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(theme.primaryColor),
                        foregroundColor: theme.outlinedButtonTheme.style.foregroundColor,
                        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]),)
        ),
    );
  }
}
