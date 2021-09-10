import 'package:expenses_alpha/page/data/budget_data.dart';
import 'package:expenses_alpha/page/home/about.dart';
import 'package:expenses_alpha/page/home/calendar.dart';
import 'package:expenses_alpha/page/home/preferences.dart';
import 'package:expenses_alpha/page/home/settings.dart';
import 'package:expenses_alpha/page/wrapper.dart';
import 'package:expenses_alpha/services/authentication.dart';
import 'package:expenses_alpha/services/colorpreference.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.red.withOpacity(0),
    systemNavigationBarDividerColor: Colors.white,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Color _currentMainColor;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      setState(() {
        _currentMainColor = ColorPreference().getMainColor(_prefs);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      initialData: null,
      value: AuthenticationService().user,
      child: MaterialApp(
        routes: {
          '/budget_data' : (context) => BudgetData(),
          '/calendar' : (context) => Calendar(),
          '/settings' : (context) => Settings(),
          '/about' : (context) => About(),
          '/preferences' : (context) => Preferences()
        },
        color: _currentMainColor,
        home: Wrapper(),
      ),
    );
  }
}



