import 'package:flutter/material.dart';
import 'package:namma_chennai/routes/walkthrough/walkthrough.dart';
import 'package:namma_chennai/routes/auth/auth.dart';
import 'package:namma_chennai/routes/form/userform.dart';
import 'package:namma_chennai/routes/dashboard/home.dart';
import 'package:namma_chennai/routes/appdetail/appdetail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namma Chennai',
      theme: ThemeData(
        // This is the theme of your application.
        primaryColor: Colors.red,
        accentColor: Colors.yellowAccent,
      ),
      initialRoute: '/start',
      home: new WalkThrough(),
      routes: <String, WidgetBuilder>{
        '/start': (BuildContext context) => new WalkThrough(),
        '/auth': (BuildContext context) => new Auth(),
        '/form': (BuildContext context) => new UserForm(),
        '/home': (BuildContext context) => new Home(),
        '/appdetail': (BuildContext context) => new AppDetailScreen(),
      },
    );
  }
}