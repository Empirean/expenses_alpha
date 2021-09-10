import 'package:expenses_alpha/models/expenseuser.dart';
import 'package:expenses_alpha/services/authentication.dart';
import 'package:expenses_alpha/services/database.dart';
import 'package:expenses_alpha/shared/loading.dart';
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
  int _sortColumnIndex;
  bool _isAscending = false;
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
      backgroundColor: Colors.pink,
      appBar: AppBar(
        shadowColor: Colors.white,
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

              _path = _budgetData[0].id;

              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/main.png"),
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
                                          return Loading();
                                      }

                                    );
                                  }
                                  else{
                                    return Loading();
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
                                              _days = _generateDayList(_currentDate);
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
                                          onTap: () async {
                                            dynamic _result = await Navigator.pushNamed(context, "/calendar", arguments: {
                                              "STARTING_DATE" : _currentDate
                                            });

                                            if (_result != null){
                                              setState(() {
                                                _currentDate =  new DateTime(_result["NEW_DATE"].year, _result["NEW_DATE"].month, _currentDate.day);
                                                _days = _generateDayList(_currentDate);
                                              });
                                            }

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
                                              _days = _generateDayList(_currentDate);
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
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Row(
                              children: [
                                StreamBuilder(
                                    stream: DatabaseService(
                                        path: user.uid + "/" + _path + "/EXPENSES"
                                    ).allDocumentsAndSort(
                                        orderBy: "EXPENSE_NAME",
                                        descending: !_isAscending
                                    ),
                                    builder: (context, expenses) {
                                      if (expenses.hasData){
                                        return StreamBuilder(
                                            stream: _getRows(expenses, user.uid),
                                            builder: (context, expenseRows) {
                                              if (expenseRows.hasData) {
                                                return  DataTable(
                                                  decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
                                                  dividerThickness: 5,
                                                  showBottomBorder: true,
                                                  headingRowColor: MaterialStateColor.resolveWith((states) => Colors.red),
                                                  sortColumnIndex: _sortColumnIndex,
                                                  sortAscending: _isAscending,
                                                  columns: _getColumns(),
                                                  rows:expenseRows.data,);
                                              }
                                              else{
                                                return  DataTable(
                                                  headingRowColor: MaterialStateColor.resolveWith(
                                                          (states) => Colors.red),
                                                  columns: _getColumns(),
                                                  rows:[],);
                                              }
                                            }
                                        );
                                      }
                                      else {
                                        return  DataTable(
                                          headingRowColor: MaterialStateColor.resolveWith(
                                                  (states) => Colors.red),
                                          columns: _getColumns(),
                                          rows:[],);
                                      }
                                    }),
                              ],
                            )
                        ),
                      ),
                    ),
                    Card(
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      color: Colors.red,
                      child: GestureDetector(
                        onTap: () {
                          List<double> _expensesInitEntries = [];
                          for (int i = 0; i < _getNumberOfDays(); i++) {
                            _expensesInitEntries.add(0.0);
                          }

                          Map<String, dynamic> data = {
                            "EXPENSE_ID" : DateFormat("MMyyyy").format(_currentDate) + DateFormat("Hms").format(DateTime.now()),
                            "EXPENSE_NAME" : "Untitled",
                            "EXPENSE_DATA" : _expensesInitEntries
                          };

                          DatabaseService(path: user.uid + "/" + _path + "/EXPENSES").addExpenseEntry(data);

                          final snackBar = SnackBar(
                            content: Text("New Entry has been added"),
                            action: SnackBarAction(
                              label: "Dismiss",
                              onPressed: () {},
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: ListTile(
                          title: Center(child: Text("New Entry",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0
                            ),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Loading();
          }
          else{
            return Loading();
          }

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
            onSort: i == "Entries" ? onSort : null,
              label: Expanded(
                child: Text(i,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                  textAlign: i == "Entries" ? TextAlign.start : TextAlign.right,
                ),
              ),
            numeric: i == "Entries" ? false : true,
          )
      );
    }

    return _dataColumns;
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      this._sortColumnIndex = columnIndex;
      this._isAscending = ascending;
    });
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

    var expenseData = expenses.data.docs;

    for (int i = 0; i < expenses.data.size; i++){

      List<DataCell> _cellList = [];

      for(int j = 0; j < _getNumberOfDays() + 1; j++)
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
            onLongPress: () {
              showModalBottomSheet(backgroundColor: Colors.pink.withOpacity(0.9),
                  context: context,
                  builder: (context) {
                return Column(
                  children: [
                    SizedBox(height: 50,),
                    Text("Delete " + expenseData[i]["EXPENSE_NAME"] + "?",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0
                      ),
                    ),
                    SizedBox(height: 50,),
                    Card(
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      color: Colors.red,
                      child: GestureDetector(
                        onTap: () {
                          DatabaseService(path: userId + "/" + _path + "/EXPENSES").deleteExpenseEntry(expenseData[i].id);
                          Navigator.pop(context);
                        },
                        child: ListTile(
                          title: Center(child: Text("Delete",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0
                            ),
                          )),
                        ),
                      ),
                    ),
                    Card(
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      color: Colors.red,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: ListTile(
                          title: Center(child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0
                            ),
                          )),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/confused_cat.png"),
                      radius: 50.0,
                    )
                  ],
                );
              });
            },
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
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
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
        color: MaterialStateColor.resolveWith((states) => Colors.pink.withOpacity(0.9))
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
