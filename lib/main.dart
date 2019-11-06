import 'dart:io';

import 'package:expense_app/widgets/chart.dart';
import 'package:expense_app/widgets/transaction_list.dart';
import 'package:expense_app/widgets/new_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracking App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        //main range of ONE color for the whole app.
        accentColor: Colors.lightGreen[300],
        //alternative color for button, etc...
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        //choose an imported font through using .yaml file
        //primary font for the whole app.
        textTheme: ThemeData.light().textTheme.copyWith(
              //setting theme for all 'title' text that is outside of app bar.
              //ThemeData.light() vs dark mode.
              //copyWith() = override.
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[200],
              ),
            ),
        appBarTheme: AppBarTheme(
          //setting theme for app bar only.
          textTheme: ThemeData.light().textTheme.copyWith(
                //setting theme for title within the appBar.
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: 'BR shirt', date: DateTime.now(), amount: 30.50),
    // Transaction(id: 't2', title: 'Milk', date: DateTime.now(), amount: 4.95),
  ];

  List<Transaction> get _recentTransaction {
    return _userTransactions.where((transaction) {
      //where() = to get a sublist from main list.

      return transaction.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTransaction = Transaction(
      title: title,
      amount: amount,
      date: date,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _promptNewTransaction(BuildContext sheet_context) {
    showModalBottomSheet(
        //bring up the sheet to enter title and amount
        //showModelBottomSheet = bring pop-up sheet and prevent interaction with the rest of the screen.
        //need context and builder.
        context: sheet_context,
        builder: (_) {
          //which Widget to build.
          return GestureDetector(
            //GestureDetector = create behavior for an event/tap gesture.
            child: NewTransaction(_addNewTransaction),
            onTap: () {},
            //what to do when the user tap.
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String transaction_id) {
    setState(() {
      _userTransactions.removeWhere(
          (one_transaction) => one_transaction.id == transaction_id);
    });
  }

  var _showChart = false;

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense Tracking App'),
            trailing: Row(
              children: [
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.add,
                  ),
                  onTap: () => _promptNewTransaction(context),
                ),
              ],
              mainAxisSize: MainAxisSize.min,
              //only take as much space as the child needs.
            ),
          )
        : AppBar(
            title: Text('Expense Tracking App'),
            //backgroundColor: Colors.brown,
            actions: <Widget>[
              IconButton(
                //the add button in the appBar
                icon: Icon(Icons.add),
                onPressed: () => _promptNewTransaction(context),
              ),
            ],
          );

    var availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    //MediaQuery.of(context).padding.top = the status bar at the top screen.

    final _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    //check if orientation is in lanscape mode.

    final bodyPage = SafeArea(
      //SafeArea = widget is taken into available space minus the notch or the space bar on IOS.
      child: SingleChildScrollView(
        //SingleChildScrollView = scrollable view.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //main-axis for column is vertical align.
          crossAxisAlignment: CrossAxisAlignment.center,
          //cross-axis for column is horizontal align.

          children: [
            if (_isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart'),
                  Switch.adaptive(
                    value: _showChart,
                    onChanged: (switch_state) {
                      setState(() {
                        _showChart = switch_state;
                      });
                    },
                  )
                ],
              ),
            if (_isLandscape)
              _showChart == true
                  ? Container(
                      child: Chart(_recentTransaction),
                      height: availableHeight * 1,
                    )
                  : Container(
                      child: TransactionList(
                          _userTransactions, _deleteTransaction),
                      height: availableHeight * 1,
                    ),
            if (!_isLandscape)
              Container(
                child: Chart(_recentTransaction),
                height: availableHeight * 0.3,
              ),
            if (!_isLandscape)
              Container(
                child: TransactionList(_userTransactions, _deleteTransaction),
                height: availableHeight * 0.7,
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: FloatingActionButton(
              //floating button at the end of the screen.
              child: Icon(Icons.add),
              onPressed: () => _promptNewTransaction(context),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
