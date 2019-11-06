import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

/**
 * used to store the list of transactions
 */
class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransactions;
  final Function _deleteTransaction;

  TransactionList(this._userTransactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: _userTransactions.isEmpty
          ? LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: <Widget>[
                    Text(
                      'No transaction added',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.7,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            )
          : ListView.builder(
              //the parent widget must have a height because ListView has infinite height, which wil not show on screen
              //create a scollable view for a list of item.
              //need to have itemBuilder and itemCount

              itemCount: _userTransactions.length,
              //number of item in the list.

              itemBuilder: (buildContext, index) {
                //to return a widget for each item in the list
                //need to have index to iterate and the buildContext
                return Card(
                  elevation: 8,
                  margin: EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 10,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.orange,
                        child: Text(
                          '\$${_userTransactions[index].amount}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      title: Text(
                        '${_userTransactions[index].title}',
                        style: Theme.of(context).textTheme.title,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd()
                            .format(_userTransactions[index].date),
                      ),
                      trailing: MediaQuery.of(context).size.width > 350
                          ? FlatButton.icon(
                              label: Text('Delete'),
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).errorColor,
                              ),
                              textColor: Theme.of(context).errorColor,
                              onPressed: () => _deleteTransaction(
                                  _userTransactions[index].id),
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).errorColor,
                              ),
                              onPressed: () => _deleteTransaction(
                                  _userTransactions[index].id),
                            ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
