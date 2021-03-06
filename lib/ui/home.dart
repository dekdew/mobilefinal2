import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/currentUser.dart';

SharedPreferences sharedPreferences;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  String _data = '';
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> writeContent(String data) async {
    final file = await _localFile;
    file.writeAsString('$data');
    return file;
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      print(contents);
      this._data = contents;
      CurrentUser.quote = contents;
      return this._data;
    } catch (e) {
      // If there is an error reading, return a default String
      return '';
    }
  }

  @override
  void setState(fn) {
    super.setState(fn);
    readContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Hello ' + CurrentUser.name),
              subtitle: Text('This is my quote "' + CurrentUser.quote + '"'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('PROFILE SETUP'),
                onPressed: () {
                  
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('MY FRIENDS'),
                onPressed: () {
                  
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('SIGN OUT'),
                onPressed: () {
                  clearSharedPreferences() async {
                  sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.setString('userId', '');
                  sharedPreferences.setString('name', '');
                }

                clearSharedPreferences();
                writeContent('');

                CurrentUser.userId = null;
                CurrentUser.name = null;
                CurrentUser.age = null;
                CurrentUser.password = null;
                CurrentUser.quote = null;
                Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
