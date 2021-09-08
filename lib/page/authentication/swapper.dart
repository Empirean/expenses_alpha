import 'package:expenses_alpha/page/authentication/login.dart';
import 'package:expenses_alpha/page/authentication/register.dart';
import 'package:flutter/material.dart';

class Swapper extends StatefulWidget {
  const Swapper({Key key}) : super(key: key);

  @override
  _SwapperState createState() => _SwapperState();
}

class _SwapperState extends State<Swapper> {

  bool togglePage = true;

  void toggle(){
    setState(() {
      togglePage = !togglePage;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (togglePage){
      return Login(toggleView: toggle,);
    }
    else{
      return Register(toggleView: toggle,);
    }
  }
}

