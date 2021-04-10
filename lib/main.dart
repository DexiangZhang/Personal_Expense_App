import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/transaction_list.dart';
import './widgets/bottom_sheet.dart';
import './widgets/chart.dart';
import './models/transaction.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Personal Expense',

      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.purpleAccent,
        errorColor: Colors.redAccent,
        fontFamily: 'Quicksand',

        textTheme: TextTheme(
          headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
          ),
          bodyText1: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 23,
              fontWeight: FontWeight.bold,
          ),
          bodyText2: TextStyle(
            color: Colors.blueGrey,
            fontSize: 17,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      home: MyHomePage(),

    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {

  // this is a transacation (variable) that holds a list of Transaction (own class)
  final List<Transaction> _userTransaction = [

    /* since it is  Transaction type, we need to create a transaction based on its constructor
    if we hard code it by ourselves:
    Transaction(
      id: 'L2',
      title: 'Weekly Groceries',
      date: DateTime.now(),
      amountSpend: 16.53,
    )
     */
  ];

  List<Transaction> get _recentTransactions {

    /*
    this .where(boolean_Statement) method is built by flutter, that will only capture and return the newly list
    when the boolean statement is true, else ignore that item,
     */
    return _userTransaction.where((element) {

      /*
      return the transaction in which the date of transaction is after
      the date you choose inside isAfter()
       */
      return element.date.isAfter(
          DateTime.now().subtract(
              Duration(days: 7)
          ),
      );

    }).toList();
  }

  bool _showChart = false;

  void _addNewTransaction(String txTitle, double amount, DateTime chosenDate) {

    final Transaction newTran = Transaction(
      title: txTitle,
      amountSpend: amount,
      date: chosenDate,
      id: DateTime.now().toString(),    // gives specific times something like:  9/21/2020 10:30:20
    );

    setState(() {
      _userTransaction.add(newTran);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tran) {
        return tran.id == id;
      });
    });

  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        /*
         it is what widgets get show within the sheet, "_" means ctx here, it's
         like you accept the arg, but don't plan to use it
         */
        builder: (_) {
          return GestureDetector(
            // this avoid you click the sheet itself to close it
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            /*
             this is to avoid you close the sheet by accident that you click the
             transaction part in the sheet
             */
            behavior: HitTestBehavior.opaque,
          );
        }
    );
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery, AppBar appBarPart, Widget txListWidget ) {

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Show Chart",
            // this is use for IOS device, since currently IOS Widget is still limited
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBarPart.preferredSize.height -
                      mediaQuery.padding.top) * 0.7,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery, AppBar appBarPart, Widget txListWidget ) {
    return [Container(
        height: (mediaQuery.size.height
            - appBarPart.preferredSize.height
            - mediaQuery.padding.top)
            * 0.3,
        child: Chart(_recentTransactions)
    ),  txListWidget ];
  }

  Widget _iphoneTopBar() {
    return CupertinoNavigationBar(
      middle: Text(
        'Personal Expense',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          ),
        ],
      ),
    );
  }

  Widget _androidTopBar() {
    return AppBar(
      title: Container(
        alignment: Alignment.center,
        child: Text(
          'Personal Expense',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBarPart = Platform.isIOS
        ? _iphoneTopBar()
        : _androidTopBar();

    final txListWidget = Container(
        height: (mediaQuery.size.height
            - appBarPart.preferredSize.height
            - mediaQuery.padding.top)
            * 0.7,
        child:  TransactionList(_userTransaction, _deleteTransaction)
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /*
            Belows return a list of widgets, with "..." we can pull out item of that list and mark
          each element of that list as a normal widget, they are no longer widget inside a list but an individual widget
           */
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBarPart, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBarPart, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
          child: pageBody,
          navigationBar: appBarPart,
        )
        : Scaffold(
          appBar: appBarPart,
          body: pageBody,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Platform.isIOS
            ? Container()
            : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
           ),
        );
    }
}
