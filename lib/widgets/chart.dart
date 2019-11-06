import 'package:expense_app/models/transaction.dart';
import 'package:expense_app/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  List<Transaction> _userTransactions;

  Chart(this._userTransactions);

  List<Map<String, Object>> get getTransactionByDate {
    return List.generate(7, (index) {
      //a list of 7 days of the week with total amount for each day
      double sum_of_one_date = 0;

      final targetDate = DateTime.now().subtract(Duration(days: index));
      //create each day backward from today.

      for (Transaction one_transaction in _userTransactions) {
        if (one_transaction.date.day == targetDate.day &&
            one_transaction.date.month == targetDate.month &&
            one_transaction.date.year == targetDate.year) {
          sum_of_one_date += one_transaction.amount;
        }
      }
      return {
        'day': DateFormat.E().format(targetDate).substring(0, 1),
        //get the first letter from each weekday.
        'amount': sum_of_one_date,
      };
    }).reversed.toList();
  }

  double get sumOfAllTransaction {
  //get total amount of all transaction
    return getTransactionByDate.fold(0.0, (_, one_date) {
      return one_date['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(6),
      child: Padding(
          padding: EdgeInsets.all(4),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: getTransactionByDate.map((one_date) {
            return Flexible(
              fit: FlexFit.tight,
            
              child: ChartBar(
                one_date['day'],
                one_date['amount'],
                one_date['amount'] == 0.0? 0.0 : (one_date['amount'] as double) / sumOfAllTransaction,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
