import 'package:expenses_alpha/services/colorpreference.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  Color _currentMainColor;
  Color _currentHighlightColor;
  final String _url = r"https://github.com/Empirean/expenses_alpha/releases";

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
        title: Text("About"),
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
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (await canLaunch(_url)){
                    await launch(_url);
                  }
                },
                child: CircleAvatar(
                  radius: 135,
                  backgroundColor: _currentHighlightColor,
                  child: CircleAvatar(
                    radius: 132,
                    backgroundColor: Colors.white,
                    child: QrImage(
                      foregroundColor: _currentMainColor,
                      data: _url,
                      version: QrVersions.auto,
                      size: 210.0,
                    ),
                  ),
                ),
              ),
            ),
            Card(
              shape: StadiumBorder(
                side: BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
              ),
              child: ListTile(
                title: Center(
                  child: Text("App Version: 1.0.1",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

