import 'package:flutter/material.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => new _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('User Preferences'),
      ),
      body: new Center(
        child: new Text('Welcome to Home.!'),
      ),
    );
  }
}