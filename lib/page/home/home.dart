import 'package:expenses_alpha/models/expenseuser.dart';
import 'package:expenses_alpha/services/authentication.dart';
import 'package:expenses_alpha/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:expenses_alpha/shared/modesenum.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  String _path;
  DateTime _currentDate;
  List<String> _days;
  var _formatter = NumberFormat('###,###,##0.00');

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _days = _generateDayList(_currentDate);

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ExpenseUser>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Expenses"),
        actions: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red
              ),
              onPressed: () async {
                setState(() {
                  AuthenticationService().signOut();
                });
              },
              icon: Icon(Icons.logout),
              label: Text("Logout")
          )
        ],
      ),
      body: StreamBuilder(
        stream: DatabaseService(path: user.uid).watchDocuments(field: "BUDGET_DATE", filter:  DateFormat("MMyyyy").format(_currentDate)),
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            int _dataSize = snapshot.data.size;

            if (_dataSize == 0) {
              Map<String, dynamic> data = {
                "BUDGET_AMOUNT" : 0.0,
                "BUDGET_DATE" : DateFormat("MMyyyy").format(_currentDate)
              };
              DatabaseService(path: user.uid).addExpenseEntry(data);
            }
            else{
              var _budgetData = snapshot.data.docs;
              // _budgetAmount = _budgetData[0]["BUDGET_AMOUNT"].toDouble();
              _path = _budgetData[0].id;

              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.blue,
                        BlendMode.softLight
                    ),
                    image: AssetImage("assets/main.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (snapshot.data.size != 0) {
                          var _budgetData = snapshot.data.docs;
                          Navigator.pushNamed(context, "/budget_data", arguments: {
                            "MODE" : mode.budgetData,
                            "DOCUMENT_ID" : _budgetData[0].id,
                            "BUDGET_AMOUNT" : _budgetData[0]["BUDGET_AMOUNT"],
                          });
                        }
                      },
                      child: Card(
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        color: Colors.red,
                        child: ListTile(
                          title:
                            Center(
                              child: StreamBuilder(
                                stream: DatabaseService(path: user.uid + "/" + _path + "/EXPENSES").allDocuments(),
                                builder: (context, expenses){
                                  if (snapshot.hasData) {
                                    return StreamBuilder(
                                      stream: _calculateBudget(_budgetData[0]["BUDGET_AMOUNT"].toDouble(), expenses),
                                      builder: (context, calculated) {
                                        if (calculated.hasData) {
                                          return Text(calculated.data,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30.0
                                            ),
                                          );
                                        }
                                        else
                                          return Container(
                                            child: Text("No Data"),
                                          );
                                      }

                                    );
                                  }
                                  else{
                                    return Container();
                                  }
                                },
                              )
                            ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  color: Colors.red,
                                  shape: StadiumBorder(
                                      side: BorderSide(
                                          color: Colors.white,
                                          width: 1.0
                                      )
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _currentDate =  new DateTime(_currentDate.year, _currentDate.month - 1, _currentDate.day);
                                            });
                                          },
                                          child: ListTile(
                                            title: Center(
                                                child: Icon(
                                                  Icons.chevron_left,
                                                  color: Colors.white,
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            print("show calendar");
                                          },
                                          child: ListTile(
                                            title: Center(
                                                child: Text(
                                                  DateFormat('MMMM').format(_currentDate) + " " + _currentDate.year.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25.0
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _currentDate =  new DateTime(_currentDate.year, _currentDate.month + 1, _currentDate.day);
                                            });
                                          },
                                          child: ListTile(
                                            title: Center(
                                              child: Icon(
                                                Icons.chevron_right,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Row(
                              children: [
                                StreamBuilder(
                                    stream: DatabaseService(path: user.uid + "/" + _path + "/EXPENSES").allDocuments(),
                                    builder: (context, expenses) {
                                      if (expenses.hasData){
                                        return StreamBuilder(
                                            stream: _getRows(expenses, user.uid),
                                            builder: (context, expenseRows) {
                                              if (expenseRows.hasData) {

                                                return  DataTable(
                                                  headingRowColor: MaterialStateColor.resolveWith((states) => Colors.red),
                                                  columns: _getColumns(),
                                                  rows:expenseRows.data,);

                                              }
                                              else{

                                                return  Container();
                                              }
                                            }
                                        );
                                      }
                                      else {
                                        return  DataTable(
                                          headingRowColor: MaterialStateColor.resolveWith(
                                                  (states) => Colors.pink),
                                          columns: _getColumns(),
                                          rows:[],);
                                      }
                                    }),
                              ],
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 50,)
                  ],
                ),
              );
            }
            return Container();

          }
          else{
            return Container();
          }

        },

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {

          List<double> _expensesInitEntries = [];
          double x = 0;
          for (int i = 0; i < _getNumberOfDays(); i++) {
            _expensesInitEntries.add(x++);
          }

          Map<String, dynamic> data = {
            "EXPENSE_ID" : DateFormat("MMyyyy").format(_currentDate) + DateFormat("Hms").format(DateTime.now()),
            "EXPENSE_NAME" : "Entry",
            "EXPENSE_DATA" : _expensesInitEntries
          };

          DatabaseService(path: user.uid + "/" + _path + "/EXPENSES").addExpenseEntry(data);
        },
      ),
    );
  }

  List<DataColumn> _getColumns()
  {
    List<DataColumn> _dataColumns = [];

    for(var i in _days)
    {
      _dataColumns.add(
          new DataColumn(
              label: Expanded(
                child: Text(i,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                  textAlign: i == "Entries" ? TextAlign.start : TextAlign.right,
                ),
              ),
          )
      );
    }

    return _dataColumns;
  }

  int _getNumberOfDays() {
    return DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
  }

  List<String> _generateDayList(DateTime currentDay)
  {
    List<String> _returnList = [];
    _returnList.add("Entries");
    for(int i = 1; i <= _getNumberOfDays(); i++)
    {
      _returnList.add(i.toString());
    }

    return _returnList;
  }

  Stream<List<DataRow>> _getRows(var expenses, String userId) async* {
    List<DataRow> _dataRows = [];
    int _currentDayCount = DateTime(_currentDate.year, _currentDate.month, 0).day;

    var expenseData = expenses.data.docs;

    for (int i = 0; i < expenses.data.size; i++){

      List<DataCell> _cellList = [];

      for(int j = 0; j < _currentDayCount; j++)
      {
        if (j == 0)
        {
          String _expenseName = expenseData[i]["EXPENSE_NAME"];
          if (_expenseName.length > 10) _expenseName = _expenseName.substring(0,9) + "...";
          DataCell dc = new DataCell(
            Text(_expenseName,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, "/budget_data", arguments: {
                "MODE" : mode.entryName,
                "DOCUMENT_ID" : expenseData[i].id,
                "ENTRY_NAME" : expenseData[i]["EXPENSE_NAME"],
                "PATH" : userId + "/" + _path + "/EXPENSES"
              });

            }
          );
          _cellList.add(dc);
        }
        else{
          DataCell dc = new DataCell(
            Text(_formatter.format(expenseData[i]["EXPENSE_DATA"][j-1]),
              style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),
            ),
            onTap: () {

              Navigator.pushNamed(context, "/budget_data", arguments: {
                "MODE" : mode.entryData,
                "DOCUMENT_ID" : expenseData[i].id,
                "EXPENSE_VALUE" : expenseData[i]["EXPENSE_DATA"][j-1],
                "PATH" : userId + "/" + _path + "/EXPENSES",
                "EXPENSE_SET" : expenseData[i]["EXPENSE_DATA"],
                "EXPENSE_INDEX" : j-1
              });

            }
          );

          _cellList.add(dc);

        }
      }
      _dataRows.add(new DataRow(
          cells: _cellList,
          color: MaterialStateColor.resolveWith((states) => Colors.blueAccent.withOpacity(0.4))
      ));
    }

    yield _dataRows;
  }

  Stream<String> _calculateBudget(double budget, var expenses) async* {

    double _budget = budget;
    int _currentDayCount = DateTime(_currentDate.year, _currentDate.month + 1, 0).day;

    var expenseData = expenses.data.docs;
    for (int i = 0; i < expenses.data.size; i++){
      for(int j = 0; j < _currentDayCount; j++) {

        _budget = _budget - double.parse(expenseData[i]["EXPENSE_DATA"][j].toString());
      }
    }
    yield _formatter.format(_budget).toString();
  }
}
