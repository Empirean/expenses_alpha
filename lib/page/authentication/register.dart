import 'package:expenses_alpha/services/authentication.dart';
import 'package:expenses_alpha/shared/loading.dart';
import 'package:expenses_alpha/shared/textdecor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String _email = "";
  String _password = "";
  String _errorText = "";
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Register"),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.red
            ),
            icon: Icon(Icons.login),
            label: Text("Login"),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/main.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Visibility(
                visible: _errorText.length > 0 ? true : false,
                child: Card(
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  child: ListTile(
                    title: Text(_errorText,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Card(
                child: TextFormField(
                  validator: (val) => val.isEmpty ? "Please provide an email address" : null,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                  decoration: textDecoration.copyWith(
                    hintText: "email@example.com",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _email = val;
                    });

                  },
                ),
              ),
              Card(
                child: TextFormField(
                  validator: (val) => val.length < 6 ? "Password needs to be longer than 6 characters" : null,
                  obscureText: true,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                  decoration: textDecoration.copyWith(
                    hintText: "password",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _password = val;
                    });
                  },

                ),
              ),
              SizedBox(height: 10,),
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
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState.validate())
                    {
                      setState(() {
                        _isLoading = true;
                      });
                      dynamic result = await AuthenticationService().signUpEmail(_email, _password);
                      if (result is String){
                        setState(() {
                          _errorText = result;
                          _isLoading = false;
                        });
                      }

                    }
                  },
                  child: ListTile(
                    title: Center(child: _isLoading ?
                    Loading() :
                    Text("Register",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
