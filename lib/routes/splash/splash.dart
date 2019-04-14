import 'package:flutter/material.dart';
import 'package:namma_chennai/locale/all_translations.dart';
import 'dart:async';
import 'package:namma_chennai/routes/walkthrough/walkthrough.dart';
import 'package:namma_chennai/routes/auth/auth.dart';
import 'package:namma_chennai/utils/default_data.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';

SharedPrefs _sharedPrefs = new SharedPrefs();

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    _sharedPrefs.getApplicationSavedInformation("loggedinuser").then((val) {
      if (val == null || val.trim() == "") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Auth()));
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
      resizeToAvoidBottomPadding: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 100.0,
                        child: Image(
                          image: AssetImage(
                              'assets/images/logo/techforcities.png'),
                          width: 150.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Text(
                        allTranslations.text('app_title'),
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        child: Divider(
                          color: Colors.blueAccent,
                          height: 30,
                        ),
                      ),
                      Text(
                        allTranslations.text('tag_line'),
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
              Image(
                image: AssetImage('assets/images/logo/splash_bg.png'),
                width: MediaQuery.of(context).size.width,
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        ),
                        CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        ),
                        Text(
                          allTranslations.text('developed_by'),
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 16.0),
                        ),
                        Text(
                          allTranslations.text('translation_0'),
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 14.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        ),
                      ],
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
