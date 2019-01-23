import 'package:flutter/material.dart';
import 'dart:async';
import 'package:namma_chennai/routes/walkthrough/walkthrough.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';

SharedPrefs _sharedPrefs = new SharedPrefs();

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    _sharedPrefs.getApplicationSavedInformation("loggedinuser").then((val) {
      if (val == null || val.trim() == "") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WalkThrough()));
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
    );
  }
}
