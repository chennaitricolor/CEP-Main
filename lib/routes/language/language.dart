import 'package:flutter/material.dart';
import 'package:namma_chennai/locale/all_translations.dart';

class LanguagePreferences extends StatefulWidget {
  @override
  _LangPrefState createState() => new _LangPrefState();
}

class _LangPrefState extends State<LanguagePreferences> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
        child: new Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            new Text(
              'Language',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30.0,
                  color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            new Text(
              'Choose your preference',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                      // boxShadow: <BoxShadow>[
                      //   BoxShadow(
                      //     color: Colors.white70,
                      //     offset: Offset(1.0, 6.0),
                      //     blurRadius: 20.0,
                      //   ),
                      // ],
                      border: new Border(
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
                            new Text(
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
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: new BoxDecoration(
                      // boxShadow: <BoxShadow>[
                      //   BoxShadow(
                      //     color: Colors.white70,
                      //     offset: Offset(1.0, 6.0),
                      //     blurRadius: 20.0,
                      //   ),
                      // ],
                      border: new Border(
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
                            new Text(
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
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: new BoxDecoration(
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //     color: Colors.white70,
                  //     offset: Offset(1.0, 6.0),
                  //     blurRadius: 20.0,
                  //   ),
                  // ],
                  border: new Border(
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
                        new Text(
                          "Aஅ",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 100.0,
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 0),
                        //   child: Text(
                        //     'தnglish',
                        //   ),
                        // )
                      ],
                    )),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                child: Text(
                  'Go back',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Color(0xFF475d9a),
                      fontWeight: FontWeight.w700,
                      fontSize: 19.0),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}