import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';


class TransactionList extends StatelessWidget {

  final List<Transaction> transactions;
  final Function deleteTran;

  TransactionList(this.transactions, this.deleteTran);

  @override
  Widget build(BuildContext context) {

      // if tran is empty then show column widget(a text and image), if has something, then output the transaction
      return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraint) {
            return Column(
              children: <Widget>[
                Text(
                  "No Transaction Available!",
                  style: Theme.of(context).textTheme.headline6,
                ),

                SizedBox(
                  height: 20,
                ),
                // Why need container? since "fit" is for its parent class, which original is column(),
                // but column() doesn't has height, so we need to wrap it with container()
                Container(
                  height: constraint.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
            return TransactionItem(
                transaction: transactions[index],
                deleteTran: deleteTran
            );
        }, // itembuilder()

        itemCount: transactions.length,
      );
  }
}



