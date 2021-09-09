import 'package:expenses_alpha/models/expenseuser.dart';
import 'package:expenses_alpha/shared/modesenum.dart';
import 'package:expenses_alpha/shared/textdecor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:expenses_alpha/services/database.dart';

class BudgetData extends StatefulWidget {
  @override
  _BudgetDataState createState() => _BudgetDataState();
}

// form variables
final _formKey = GlobalKey<FormState>();
final _controller = TextEditingController();

class _BudgetDataState extends State<BudgetData> {

  // parameters
  mode _mode;
  Map _data = {};
  String _title = "Not title";
  String _hint = "No hint";
  String _documentId = "";
  String _entryData = "";
  String _path = "";
  int _index;
  List<dynamic> _expenseSet = [];

  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      _controller.clear();
      _data = ModalRoute.of(context).settings.arguments;
      if (_data != null) {

        // mode
        _mode = _data["MODE"];
        _documentId = _data["DOCUMENT_ID"];

        // budget data entry
        if (_mode == mode.budgetData) {

          _title = "Budget Amount";
          _hint = "amount";

          setState(() {
            _controller.text = _data["BUDGET_AMOUNT"].toString();
          });
        }

        // expense entry name
        if (_mode == mode.entryName) {

          _title = "Expense Description";
          _hint = "description";

          _path = _data["PATH"];
          setState(() {
            _controller.text = _data["ENTRY_NAME"].toString();
          });
        }

        // expense entry value
        if (_mode == mode.entryData) {

          _title = "Expense Value";
          _hint = "amount";

          _path = _data["PATH"];
          _expenseSet = _data["EXPENSE_SET"];
          _index = int.parse(_data["EXPENSE_INDEX"].toString());

          setState(() {
            _controller.text = _data["EXPENSE_VALUE"].toString();
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_title),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.red
            ),
            icon: Icon(Icons.save_rounded),
            label: SizedBox(),
            onPressed: () async {

              final user = Provider.of<ExpenseUser>(context, listen:false);

              if (_formKey.currentState.validate())
              {
                // budget data entry
                if (_mode == mode.budgetData) {
                  Map<String, dynamic> data = {
                    "BUDGET_AMOUNT" : double.parse(_entryData),
                  };
                  DatabaseService(path: user.uid).updateExpenseEntry(data, _documentId);
                }

                if (_mode == mode.entryName) {
                  Map<String, dynamic> data = {
                    "EXPENSE_NAME" : _entryData
                  };
                  DatabaseService(path: _path).updateExpenseEntry(data, _documentId);
                }

                if (_mode == mode.entryData) {
                  _expenseSet[_index] = int.parse(_entryData);
                  Map<String, dynamic> data = {
                    "EXPENSE_DATA" : _expenseSet
                  };
                  DatabaseService(path: _path).updateExpenseEntry(data, _documentId);
                }

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/main.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Form(
                key: _formKey,
                child: Card(
                  child: TextFormField(
                    controller: _controller,
                    maxLength: _mode == mode.entryName ? 30 : 15,
                    keyboardType: _mode == mode.entryName ? TextInputType.text : TextInputType.numberWithOptions(decimal: true, signed: false),
                    inputFormatters: _mode == mode.entryName ? [] : [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        try{
                          final text = newValue.text;
                          if (text.isNotEmpty) double.parse(text);
                          return newValue;
                        }catch (e) {}
                        return oldValue;
                      }),
                    ],
                    validator: (val) => val.isEmpty ? _title + " cannot be empty" : null,
                    style: TextStyle(
                      color: Colors.white
                    ),
                    cursorColor: Colors.white,
                    decoration: textDecoration.copyWith(
                      hintText: _hint,
                      hintStyle: TextStyle(
                        color: Colors.white
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        _entryData = val;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
