import 'package:flutter/material.dart';
import 'package:namma_chennai/locale/all_translations.dart';

class LanguagePreferences extends StatefulWidget {
  @override
  _LangPrefState createState() => new _LangPrefState();
}

class _LangPrefState extends State<LanguagePreferences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.center,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.5, 0.5],
            tileMode: TileMode.clamp,
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.redAccent,
              Color(0xFFEEEEEE),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50),
            ),
            Text(
              'Language',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30.0,
                  color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Text(
              'Choose your preference',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(top: 100),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 4, color: Colors.redAccent))),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: FlatButton(
                        color: Colors.white,
                        onPressed: () async {
                          await allTranslations.setNewLanguage("en");
                          setState(() {});
                          Navigator.pushNamed(context, "/auth");
                        },
                        child: Column(
                          children: <Widget>[
                            Text(
                              "A",
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 100.0,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 4, color: Colors.redAccent))),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: FlatButton(
                        color: Colors.white,
                        onPressed: () async {
                          await allTranslations.setNewLanguage("ta");
                          setState(() {});
                          Navigator.pushNamed(context, "/auth");
                        },
                        child: Column(
                          children: <Widget>[
                            Text(
                              "அ",
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 100.0,
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 4, color: Colors.redAccent))),
              child: SizedBox(
                height: 140,
                child: FlatButton(
                    color: Colors.white,
                    onPressed: () async {
                      await allTranslations.setNewLanguage("te");
                      setState(() {});
                      Navigator.pushNamed(context, "/auth");
                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Aஅ",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 100.0,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}