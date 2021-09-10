import 'package:expenses_alpha/page/data/budget_data.dart';
import 'package:expenses_alpha/page/home/about.dart';
import 'package:expenses_alpha/page/home/calendar.dart';
import 'package:expenses_alpha/page/home/settings.dart';
import 'package:expenses_alpha/page/wrapper.dart';
import 'package:expenses_alpha/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.red,
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
        },
        color: Colors.red,
        home: Wrapper(),
      ),
    );
  }
}



