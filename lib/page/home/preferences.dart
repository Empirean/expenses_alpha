import 'package:expenses_alpha/services/colorpreference.dart';
import 'package:expenses_alpha/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key key}) : super(key: key);

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {

  Color _currentMainColor;
  Color _newMainColor;

  Color _currentHighlightColor;
  Color _newHighlightColor;

  @override
  void initState() {

    Future.delayed(Duration.zero, () async {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      setState(() {
        _currentMainColor = ColorPreference().getMainColor(_prefs);
        _currentHighlightColor = ColorPreference().getHighColor(_prefs);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: _currentMainColor,
        title: Text("Preferences"),
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
            Spacer(),
            Card(
              shape: StadiumBorder(
                side: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              color: _currentMainColor,
              child: GestureDetector(
                onTap: () {

                  AlertDialog alertDialog = AlertDialog(
                    title: Text("Main Color"),
                    content: StatefulBuilder(
                      builder: (builder, setInnerState) {
                        return Container(
                          child: SingleChildScrollView(
                            child: ColorPicker(
                              enableAlpha: false,
                              showLabel: false,
                              pickerColor: _currentMainColor,
                              onColorChanged: (_pickerColor) {
                                setState(() {
                                    _newMainColor = _pickerColor;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel",
                            style: TextStyle(
                                color: _currentMainColor
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: () async {

                            setState(() {
                              _currentMainColor = _newMainColor;
                            });

                            SharedPreferences _prefs = await SharedPreferences.getInstance();

                            int _currentColorRed = _currentMainColor.red;
                            int _currentColorBlue = _currentMainColor.blue;
                            int _currentColorGreen = _currentMainColor.green;

                            await _prefs.setInt(Constants.KEY_MAIN_RED, _currentColorRed);
                            await _prefs.setInt(Constants.KEY_MAIN_BLUE, _currentColorBlue);
                            await _prefs.setInt(Constants.KEY_MAIN_GREEN, _currentColorGreen);


                            Navigator.pop(context);
                          },
                          child: Text("Confirm",
                            style: TextStyle(
                              color: _currentMainColor,
                              fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                    ],
                  );

                  showDialog(
                    context: context,
                    builder: (_) => alertDialog,
                  );

                },
                child: ListTile(
                  title: Center(child:
                  Text("Main Color",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0
                    ),
                  )
                  ),
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
              color: _currentHighlightColor,
              child: GestureDetector(
                onTap: () {
                  AlertDialog alertDialog = AlertDialog(
                    title: Text("Highlight Color"),
                    content: StatefulBuilder(
                      builder: (builder, setInnerState) {
                        return Container(
                          child: SingleChildScrollView(
                            child: ColorPicker(
                              enableAlpha: false,
                              showLabel: false,
                              pickerColor: _currentHighlightColor,
                              onColorChanged: (_pickerColor) {
                                setState(() {
                                  _newHighlightColor = _pickerColor;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel",
                            style: TextStyle(
                                color: _currentHighlightColor
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: () async {
                            setState(() {
                              _currentHighlightColor = _newHighlightColor;
                            });

                            SharedPreferences _prefs = await SharedPreferences.getInstance();
                            int _currentColorRed = _currentHighlightColor.red;
                            int _currentColorBlue = _currentHighlightColor.blue;
                            int _currentColorGreen = _currentHighlightColor.green;

                            await _prefs.setInt(Constants.KEY_HIGH_RED, _currentColorRed);
                            await _prefs.setInt(Constants.KEY_HIGH_BLUE, _currentColorBlue);
                            await _prefs.setInt(Constants.KEY_HIGH_GREEN, _currentColorGreen);

                            Navigator.pop(context);
                          },
                          child: Text("Confirm",
                            style: TextStyle(
                                color: _currentHighlightColor,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (_) => alertDialog,
                  );
                },
                child: ListTile(
                  title: Center(child:
                  Text("Highlight Color",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0
                    ),
                  )
                  ),
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
              color: _currentHighlightColor,
              child: GestureDetector(
                onTap: () async{

                  SharedPreferences _prefs = await SharedPreferences.getInstance();

                  await _prefs.setInt(Constants.KEY_MAIN_RED, Constants.VALUE_MAIN_RED);
                  await _prefs.setInt(Constants.KEY_MAIN_GREEN, Constants.VALUE_MAIN_GREEN);
                  await _prefs.setInt(Constants.KEY_MAIN_BLUE, Constants.VALUE_MAIN_BLUE);

                  await _prefs.setInt(Constants.KEY_HIGH_RED, Constants.VALUE_HIGH_RED);
                  await _prefs.setInt(Constants.KEY_HIGH_GREEN, Constants.VALUE_HIGH_GREEN);
                  await _prefs.setInt(Constants.KEY_HIGH_BLUE, Constants.VALUE_HIGH_BLUE);

                  setState(() {
                    _currentMainColor = ColorPreference().getMainColor(_prefs);
                    _currentHighlightColor = ColorPreference().getHighColor(_prefs);
                  });
                },
                child: ListTile(
                  title: Center(child:
                  Text("Restore Defaults",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0
                    ),
                  )
                  ),
                ),
              ),
            ),
            Spacer(),
            Card(
              shape: StadiumBorder(
                side: BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
              ),
              child: ListTile(
                title: Center(
                  child: Text("You may need to restart the application to see the changes",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
