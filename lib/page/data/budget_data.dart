import 'package:expenses_alpha/models/expenseuser.dart';
import 'package:expenses_alpha/shared/textdecor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:expenses_alpha/services/database.dart';

class BudgetData extends StatefulWidget {

  @override
  _BudgetDataState createState() => _BudgetDataState();
}

class _BudgetDataState extends State<BudgetData> {

  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  String _budget = "";
  String _budgetId = "";
  Map _data = {};

  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      _data = ModalRoute.of(context).settings.arguments;
      if (_data != null) {
        setState(() {
          _budgetId = _data["DOCUMENT_ID"];
          _controller.text = _data["BUDGET_AMOUNT"].toString();
        });
      }

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Budget"),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.red
            ),
            icon: Icon(Icons.save_rounded),
            label: SizedBox(),
            onPressed: () async {
              if (_formKey.currentState.validate())
              {
                setState(() {
                  final user = Provider.of<ExpenseUser>(context, listen:false);
                  print(user.uid);

                  Map<String, dynamic> data = {
                    "BUDGET_AMOUNT" : double.parse(_budget),
                  };

                  DatabaseService(path: user.uid).updateExpenseEntry(data, _budgetId);

                  Navigator.pop(context);

                });
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
                    maxLength: 15,
                    keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                    inputFormatters: [
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
                    validator: (val) => val.isEmpty ? "Budget cannot be empty" : null,
                    style: TextStyle(
                      color: Colors.white
                    ),
                    cursorColor: Colors.white,
                    decoration: textDecoration.copyWith(
                      hintText: "budget",
                      hintStyle: TextStyle(
                        color: Colors.white
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        _budget = val;
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
