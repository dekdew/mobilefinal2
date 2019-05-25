import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
        ),
        bottomSheet: Container(
          color: Colors.lightBlue,
          child: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.notifications),
              ),
              Tab(
                icon: Icon(Icons.explore),
              ),
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            children: <Widget>[
              Center(
                  child: Text(
                "Home",
                style: TextStyle(fontSize: 30),
              )),
              Center(
                  child: Text(
                "Notify",
                style: TextStyle(fontSize: 30),
              )),
              Center(
                  child: Text(
                "Map",
                style: TextStyle(fontSize: 30),
              )),
              Center(
                  child: Text(
                "Profile",
                style: TextStyle(fontSize: 30),
              )),
              Center(
                  child: Text(
                "Setup",
                style: TextStyle(fontSize: 30),
              )),
            ],
          ),
        ),
      ),
    );
  }
}