import 'package:expenses_alpha/services/authentication.dart';
import 'package:expenses_alpha/services/colorpreference.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  Color _currentMainColor;
  Color _currentHighlightColor;

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
        title: Text("Settings"),
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
                onTap: () async {
                  setState(() {
                    Navigator.pushNamed(context, "/preferences");
                  });
                },
                child: ListTile(
                  title: Center(child:
                  Text("Preferences",
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
              color: _currentMainColor,
              child: GestureDetector(
                onTap: () async {
                  Navigator.pushNamed(context, "/about");
                },
                child: ListTile(
                  title: Center(child:
                  Text("About",
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
                onTap: () async {
                  setState(() {
                    AuthenticationService().signOut();
                    Navigator.pop(context);
                  });
                },
                child: ListTile(
                  title: Center(child:
                    Text("Logout",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0
                      ),
                    )
                  ),
                ),
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
