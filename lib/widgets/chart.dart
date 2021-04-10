import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {

  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupTransactionValues {
    // 7 means will created 7 list in total
    return List.generate(7, (index) {
      // will substract index to get the total 7 days, index=0, today -0 = today, index =1, today -1 = yesterday(one day previous)..
      final weekDay = DateTime.now().subtract(Duration(days: index),);

      var totalSum = 0.0;

      for(var i=0; i< recentTransactions.length; i++) {
        if(recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {

          totalSum += recentTransactions[i].amountSpend;
        }
      }

      // DateFormat.E() will return a shortcut day (M,T,W,TH,F..) as string based on the weekday
      return {
        'day': DateFormat.E().format(weekDay).substring(0,3),  // substring(startIndex, endindex) here Monday -> Mon
        'amount': totalSum
      };
      // using reversed , we have list that is reversed, which oldest day to the left ans so on
    }).reversed.toList();
  }
  
  double get totalSpending {
    return groupTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(10),
          // each day's bar is horizontally align
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
              groupTransactionValues.map((data) {
                return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    data['day'],
                    data['amount'],
                    totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending,
                  ),
                );
              }).toList(),
          ),
        ),
      );
  }
}
