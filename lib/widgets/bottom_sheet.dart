
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/adaptive_button.dart';

class NewTransaction extends StatefulWidget {

  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectDate;

  void _submitData() {

    if(_amountController.text.isEmpty) {
      return;
    }

    final enterTitle = _titleController.text;
    final enterAmount = double.parse(_amountController.text);

    // if there is no either name of tran, less or equal $0, no date selected, then return nothing
    if(enterTitle.isEmpty || enterAmount <= 0 || _selectDate == null) {
      return;
    }

    /*
    widget is built by flutter, with this. In statefulWidget, we can access the
    property directly from the statefulWidget class inside the state class
     */
    widget.addTx(
        enterTitle,
        enterAmount,
        _selectDate,
    );

    /*
    automatically close the topmost screen (here it means the bottom sheet, since it is latest
     screen show up) that is display  when we click "done" on soft keyboard
    */
    Navigator.of(context).pop();
  }

  /*
  display a calender with starting year and check if user cancelled the date or not,
    if yes, then return nothing and allow user to choose again next time
   */

  void _presentDatePicker () {

    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now(),
    ).then((pickDate) {
      if(pickDate == null) {
        return;
      }

      // once user click the new date, refresh the screen by call setState()
      setState(() {
        _selectDate = pickDate;
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
            left: 10,
            right: 10,
            /*
            MediaQuery.of(context).viewInsets.bottom give occupy space of overlapping view (soft keyboard)
             by adding, it makes the our bottom sheet always higher than keyboard, so we can type
             */
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                // same as TextInputType.number, but use this to allow IOS system uses decimal place
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(),
              ),

              Container(
                height: 80,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                          _selectDate == null
                              ? 'No Date Chosen!'
                              : 'Pick Date: ${DateFormat.yMd().format(_selectDate)}',
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    AdaptiveFlatButton("Choose Date", _presentDatePicker)
                  ],
                ),
              ),

              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
