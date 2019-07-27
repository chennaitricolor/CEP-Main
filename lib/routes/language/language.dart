import 'package:flutter/material.dart';
import 'package:hello_chennai/locale/all_translations.dart';
import 'package:hello_chennai/utils/default_data.dart';

class LanguagePreferences extends StatefulWidget {
  @override
  _LangPrefState createState() => new _LangPrefState();
}

class _LangPrefState extends State<LanguagePreferences> {
  @override
  Widget build(BuildContext context) {
    showLanguageSelection() {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20)),
                  Text(
                    "Choose Language",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 10, right: 10),
                    child: FlatButton(
                      color: Color(0xFFDDDDDD),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                        // showLanguageSelection();
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Tamil',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
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
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 40.0),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 100.0,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/logo/tricolor.png'),
                                width: 150.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0, left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    DefaultData.platformTitle,
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
                                    DefaultData.platformTagline,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12.0),
                                  )
                                ],
                              ),
                            ),
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
                          padding: EdgeInsets.only(bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10.0, left: 10.0),
                                child: Text(
                                  "English",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 0.0, bottom: 20.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 20.0,
                                    left: 10,
                                    right: 10),
                                child: FlatButton(
                                  color: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  onPressed: () {
                                    showLanguageSelection();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 10.0),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Choose Language',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Change as per your preference',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
