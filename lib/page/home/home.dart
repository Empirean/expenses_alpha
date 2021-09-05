import 'package:expenses_alpha/models/expenseuser.dart';
import 'package:expenses_alpha/services/authentication.dart';
import 'package:expenses_alpha/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  DateTime _currentDate;
  List<String> _days;
  double _budgetAmount = 0;
  String _path;

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
                "BUDGET_AMOUNT" : 0,
                "BUDGET_DATE" : DateFormat("MMyyyy").format(_currentDate)
              };

              DatabaseService(path: user.uid).addExpenseEntry(data);
            }
            else{

              var _budgetData = snapshot.data.docs;
              _budgetAmount = _budgetData[0]["BUDGET_AMOUNT"].toDouble();
              _path = _budgetData[0].id;
              /*
              for(int i = 1; i < _dataSize; i++){
                DatabaseService(path: user.uid).deleteExpenseEntry(_budgetData[i].id);
              }
              */
            }
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
                      setState(() {
                        if (snapshot.data.size != 0) {
                          var _budgetData = snapshot.data.docs;
                          Navigator.pushNamed(context, "/budget_data", arguments: {
                            "DOCUMENT_ID" : _budgetData[0].id,
                            "BUDGET_AMOUNT" : _budgetData[0]["BUDGET_AMOUNT"],
                          });
                        }
                      });
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
                        title: Center(child: Text(
                          _budgetAmount.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
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
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: StreamBuilder(
                              stream: DatabaseService(path: user.uid + "/" + _path + "/EXPENSES").allDocuments(),
                              builder: (context, expenses) {
                                if (expenses.hasData){
                                  return StreamBuilder(
                                      stream: _getRows(expenses),
                                      builder: (context, expenseRows) {
                                        if (expenseRows.hasData) {

                                          return  DataTable(
                                            headingRowColor: MaterialStateColor.resolveWith(
                                                    (states) => Colors.pink),
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
                              })
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );

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
          List<int> expensesEntries = [];
          int _expenseLoader = 100;
          for (int i = 0; i < DateTime(_currentDate.year, _currentDate.month + 1, 0).day; i++) {
            expensesEntries.add(_expenseLoader);
            _expenseLoader += 100;
          }

          Map<String, dynamic> data = {
            "EXPENSE_ID" : DateFormat("MMyyyy").format(_currentDate) + DateFormat("Hms").format(DateTime.now()),
            "EXPENSE_NAME" : "Entry",
            "EXPENSE_DATA" : expensesEntries
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
          new DataColumn(label: Text(i,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),

          ))
      );
    }

    return _dataColumns;
  }

  List<String> _generateDayList(DateTime currentDay)
  {
    List<String> _returnList = [];
    _returnList.add("Entries");
    for(int i = 1; i <= DateTime(_currentDate.year, _currentDate.month + 1, 0).day; i++)
    {
      _returnList.add(i.toString());
    }

    return _returnList;
  }

  Stream<List<DataRow>> _getRows(var expenses) async* {
    List<DataRow> _dataRows = [];
    int _currentDayCount = DateTime(_currentDate.year, _currentDate.month, 0).day;

    var expenseData = expenses.data.docs;

    for (int i = 0; i < expenses.data.size; i++){

      List<DataCell> _cellList = [];

      for(int j = 0; j < _currentDayCount; j++)
      {


        if (j == 0)
        {

          DataCell dc = new DataCell(
              Text(expenseData[i]["EXPENSE_NAME"],
                style: TextStyle(
                  fontSize: 30,
                ),
              )
          );
          _cellList.add(dc);
        }
        else{
          DataCell dc = new DataCell(
              Text(expenseData[i]["EXPENSE_DATA"][j-1].toString(),
                style: TextStyle(
                  fontSize: 30,
                ),
              )
          );
          _cellList.add(dc);

        }
      }
      _dataRows.add(new DataRow(cells: _cellList));
    }
    // print(_dataRows.length);
    yield _dataRows;
  }
}
