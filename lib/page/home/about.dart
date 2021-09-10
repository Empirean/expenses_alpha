import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

  final String _url = r"https://github.com/Empirean/expenses_alpha/releases";

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
            SizedBox(height: 50,),
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (await canLaunch(_url)){
                    await launch(_url);
                  }
                },
                child: CircleAvatar(
                  radius: 135,
                  backgroundColor: Colors.pink,
                  child: CircleAvatar(
                    radius: 132,
                    backgroundColor: Colors.white,
                    child: QrImage(
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
          ],
        ),
      ),
    );
  }
}
