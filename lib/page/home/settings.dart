import 'package:expenses_alpha/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.red,
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
            Card(
              shape: StadiumBorder(
                side: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              color: Colors.red,
              child: GestureDetector(
                onTap: () async {
                  setState(() {

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
              color: Colors.red,
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
              color: Colors.pink,
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
          ],
        ),
      ),
    );
  }
}
