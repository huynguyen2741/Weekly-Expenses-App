import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/**
 * get input about title and amount for new transaction.
 */

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _pickedDate;

  void submitData() {
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0 || _pickedDate == null) {
      return;
    }

    widget.addTransaction(
      //widget = the class StatefulWidget
      //only available in State class
      _titleController.text,
      double.parse(_amountController.text),
      _pickedDate,
    );

    Navigator.of(context).pop();
    //used to unpop the model sheet (adding new transaction sheet)
  }

  void _getDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((oneDate) {
      if (oneDate == null) return;

      setState(() {
        _pickedDate = oneDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          child: Container(
        padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        //setting the height of the keyboard = setting the height for bottom of the screen obscured by keyboard.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              //TextField = user input.
              decoration: InputDecoration(
                labelText: 'Title',
                //labelText = label for the input field.
              ),
              controller: _titleController,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: _amountController,
              onSubmitted: (_) => submitData(),
              //onChanged: (value) => amountInput = value,
            ),
            Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Text(_pickedDate == null
                      ? 'No Date Chosen?'
                      : DateFormat.yMd().format(_pickedDate)),
                  Platform.isIOS
                      ? CupertinoButton(
                          child: Text(
                            'Choose a date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.button.color,
                            ),
                          ),
                          onPressed: _getDate,
                        )
                      : FlatButton(
                          child: Text(
                            'Choose a date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.button.color,
                            ),
                          ),
                          onPressed: _getDate,
                        ),
                ],
              ),
            ),
            RaisedButton(
              child: Text('Add transaction'),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
              onPressed: submitData,
            ),
          ],
        ),
      )),
    );
  }
}
