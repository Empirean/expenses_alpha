import 'package:expenses_alpha/services/authentication.dart';
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
            image: AssetImage("assets/main.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text(_errorText,
                style: TextStyle(
                  color: Colors.orange,
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: Colors.white)
                    ),
                  ),
                  onPressed: () async{
                    if (_formKey.currentState.validate())
                    {
                      // _isLoading = true;
                      dynamic result = await AuthenticationService().signUpEmail(_email, _password);
                      // _isLoading = false;
                      setState(() {
                        if (result is String)
                          _errorText = result;
                      });
                    }
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
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
