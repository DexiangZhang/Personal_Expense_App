import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String title;
  final double amountSpend;
  final DateTime date;

  // hint: using normal one: transaction(string n) { id =n}, final variable need to initialized
  Transaction({
    @required this.id,
    @required this.title,
    @required this.amountSpend,
    @required this.date,
  });
}