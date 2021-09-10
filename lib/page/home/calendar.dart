import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  DateTime _currentDate = DateTime.now();
  int _selectedIndex = 0;
  Map _data = {};

  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      _data = ModalRoute.of(context).settings.arguments;

      if (_data != null) {
        setState(() {
          _currentDate = _data["STARTING_DATE"];
          _selectedIndex = _currentDate.month;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.red,
        title: Text("Calendar"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/main.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
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
                              // year button
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentDate =  new DateTime(_currentDate.year - 1, _currentDate.month, _currentDate.day);
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
                                child: ListTile(
                                  title: Center(
                                      child: Text(
                                        _currentDate.year.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25.0
                                        ),
                                      )
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentDate =  new DateTime(_currentDate.year + 1, _currentDate.month, _currentDate.day);
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
            // Jan to Mar
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 1 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                          Text("Jan",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0
                            ),
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 2 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                          Text("Feb",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0
                            ),
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 3 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 3;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                          Text("Mar",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0
                            ),
                          )
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Apr to Jun
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 4 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 4;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                        Text("Apr",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
                        )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 5 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 5;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                        Text("May",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
                        )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 6 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 6;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                        Text("Jun",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
                        )
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Jul to Sep
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 7 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 7;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                        Text("Jul",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
                        )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 8 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 8;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                        Text("Aug",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
                        )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 9 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 9;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                        Text("Sep",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
                        )
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Oct to Dec
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 10 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 10;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                        Text("Oct",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
                        )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 11 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 11;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                        Text("Nov",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
                        )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: _selectedIndex == 12 ? Colors.pink : Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 12;
                          _currentDate = DateTime(_currentDate.year, _selectedIndex);
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                        Text("Dec",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
                        )
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: Card(
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
                        title: Center(child:
                        Text("Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
                        )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    color: Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, {
                          "NEW_DATE" : _currentDate
                        });
                      },
                      child: ListTile(
                        title: Center(child:
                        Text("Done",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                          ),
                        )
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
