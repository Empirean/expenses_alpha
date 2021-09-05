import 'package:expenses_alpha/page/data/budget_data.dart';
import 'package:expenses_alpha/page/wrapper.dart';
import 'package:expenses_alpha/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
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
      value: AuthenticationService().user,
      child: MaterialApp(
        routes: {
          '/budget_data' : (context) => BudgetData(),
        },
        color: Colors.red,
        home: Wrapper(),
      ),
    );
  }
}



