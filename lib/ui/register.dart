import 'package:flutter/material.dart';
import '../model/user.dart';

class Register extends StatefulWidget {
  @override
  RegisterState createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  UserProvider _db = UserProvider();
  final userIdController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final passwordController = TextEditingController();

  bool isUser = false;

  int countSpace(String s) {
    int res = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == ' ') {
        res += 1;
      }
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "REGISTER",
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                  controller: userIdController,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: '',
                      labelText: 'User Id'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "กรุณาระบุ user";
                    }
                    if ((value.length < 6) || (value.length > 12)) {
                      return "ต้องมีความยาวอยู่ในช่วง 6-12 ตัวอักษร";
                    }
                  },
                ),
                new TextFormField(
                  controller: nameController,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.account_circle),
                      hintText: '',
                      labelText: 'Name'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "กรุณาระบุ ชื่อ";
                    }
                    if (countSpace(value) != 1) {
                      return "ต้องมีชื่อและนามสกุลที่ขั้นด้วย space 1 space";
                    }
                  },
                ),
                new TextFormField(
                  controller: ageController,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: '',
                      labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "กรุณาระบุ อายุ";
                    }
                    if ((int.parse(value)).compareTo(10) == -1 || (int.parse(value)).compareTo(80) == 1) {
                      return "อายุอยู่ในช่วง 10-80";
                    }
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: "Password",
                      hintText: ""),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "กรุณาระบุ password";
                    }
                    if (value.length <= 6) {
                      return "password ต้องมีความยาวมากกว่า 6";
                    }
                  },
                ),
                new Container(
                  child: new RaisedButton(
                    child: new Text(
                      'REGISTER NEW ACCOUNT',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.lightBlue,
                    onPressed: () async {
                      await _db.open("user.db");
                      Future<List<User>> allUser = _db.getAllUser();
                      User userData = User();
                      userData.userid = userIdController.text;
                      userData.name = nameController.text;
                      userData.age = ageController.text;
                      userData.password = passwordController.text;

                      //function to check if user in
                      Future isNewUserIn(User user) async {
                        var userList = await allUser;
                        for (var i = 0; i < userList.length; i++) {
                          if (user.userid == userList[i].userid) {
                            this.isUser = true;
                            return;
                          }
                        }
                      }

                      //call function
                      await isNewUserIn(userData);

                      //validate form
                      if (this._formKey.currentState.validate()) {
                        //if user not exist
                        if (!this.isUser) {
                          userIdController.text = "";
                          nameController.text = "";
                          ageController.text = "";
                          passwordController.text = "";
                          await _db.registerUser(userData);
                          Navigator.pop(context);
                        }
                      }

                      this.isUser = false;
                    }
                  ),
                  margin: new EdgeInsets.only(top: 20.0),
                ),
              ],
            ),
          )),
    );
  }
}