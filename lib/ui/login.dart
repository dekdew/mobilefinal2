import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
import '../utils/currentUser.dart';

SharedPreferences sharedPreferences;

void main() => runApp(new MaterialApp(
      title: 'Forms in Flutter',
      home: new Login(),
));

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  UserProvider _db = UserProvider();
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();
  bool isValid = false;
  int formState = 0;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If there is an error reading, return a default String
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      checkLogin(String userIdCheck) async {
        await _db.open("user.db");
        Future<List<User>> allUser = _db.getAllUser();
        Future isUserValid(String userid) async {
          var userList = await allUser;
          for (var i = 0; i < userList.length; i++) {
            if (userid == userList[i].userid) {
              // Set user
              CurrentUser.id = userList[i].id;
              CurrentUser.userId = userList[i].userid;
              CurrentUser.name = userList[i].name;
              CurrentUser.age = userList[i].age;
              CurrentUser.password = userList[i].password;
              CurrentUser.quote = await readContent();

              this.isValid = true;

              // Set SharedPreferences
              sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString("userId", userList[i].userid);
              sharedPreferences.setString("name", userList[i].name);
              return Navigator.pushReplacementNamed(context, '/home');
            }
          }
        }

        isUserValid(userIdCheck);
      }

      getCredential() async {
        sharedPreferences = await SharedPreferences.getInstance();
        String username = sharedPreferences.getString('userId');
        if (username != "" && username != null) {
          checkLogin(username);
        }
      }

      getCredential();
    });


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
                  controller: userIdController,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Pleas input your user id',
                      labelText: 'User Id'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "กรุณาระบุ user";
                    }
                  },
                ),
                TextFormField(
                  controller: passwordController,
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
                ),
                new Container(
                  child: new RaisedButton(
                    child: new Text(
                      'LOGIN',
                      style: new TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      this._formKey.currentState.validate();
                      await _db.open("user.db");
                      Future<List<User>> allUser = _db.getAllUser();

                      Future isUserValid(String userid, String password) async {
                        var userList = await allUser;
                        for (var i = 0; i < userList.length; i++) {
                          if (userid == userList[i].userid &&
                              password == userList[i].password) {
                            CurrentUser.id = userList[i].id;
                            CurrentUser.userId = userList[i].userid;
                            CurrentUser.name = userList[i].name;
                            CurrentUser.age = userList[i].age;
                            CurrentUser.password = userList[i].password;
                            CurrentUser.quote = await readContent();
                            this.isValid = true;
                            sharedPreferences = await SharedPreferences.getInstance();
                            sharedPreferences.setString(
                                "userId", userList[i].userid);
                            sharedPreferences.setString(
                                "name", userList[i].name);
                            break;
                          }
                        }
                      }

                      this.formState = 0;
                      await isUserValid(userIdController.text, passwordController.text);
                      if (!this.isValid) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("user or password ไม่ถูกต้อง"),
                            );
                          }
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/home');
                        userIdController.text = "";
                        passwordController.text = "";
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