import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
      title: 'Forms in Flutter',
      home: new Login(),
    ));

class _LoginData {
  String email = '';
  String password = '';
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                Image.asset(
                  "assets/logo.png",
                  height: 200,
                ),
                new TextFormField(
                  decoration: new InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Pleas input your user id',
                      labelText: 'User Id'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "กรุณาระบุ user";
                    }
                  },
                  onSaved: (String value) {
                    this._data.email = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: "Password",
                      hintText: "Pleas input your password"),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "กรุณาระบุ password";
                    }
                  },
                  onSaved: (String value) {
                    this._data.password = value;
                  },
                ),
                new Container(
                  child: new RaisedButton(
                    child: new Text(
                      'LOGIN',
                      style: new TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      _formKey.currentState.save();
                      // First validate form.
                      if (this._formKey.currentState.validate()) {
                        if (this._data.email == "admin" &&
                            this._data.password == "admin") {
                          Navigator.pushReplacementNamed(context, "/home");
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("user or password ไม่ถูกต้อง"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                  margin: new EdgeInsets.only(top: 20.0),
                ),
                new Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new FlatButton(
                        child: new Text('Register New Account'),
                        onPressed: () {
                          Navigator.pushNamed(context, "/register");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}