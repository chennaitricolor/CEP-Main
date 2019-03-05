import 'package:flutter/material.dart';
import 'package:namma_chennai/locale/all_translations.dart';

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
                        showLanguageSelection();
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
                                    'assets/images/logo/techforcities.png'),
                                width: 150.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0, left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "App Title",
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
                                    "Here we have Tag Line",
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
    // return Scaffold(
    //     body: SingleChildScrollView(
    //   child: Container(
    //     height: MediaQuery.of(context).size.height,
    //     decoration: BoxDecoration(
    //       // Box decoration takes a gradient
    //       gradient: LinearGradient(
    //         // Where the linear gradient begins and ends
    //         begin: Alignment.topCenter,
    //         end: Alignment.center,
    //         // Add one stop for each color. Stops should increase from 0 to 1
    //         stops: [0.5, 0.5],
    //         tileMode: TileMode.clamp,
    //         colors: [
    //           // Colors are easy thanks to Flutter's Colors class.
    //           Colors.redAccent,
    //           Color(0xFFEEEEEE),
    //         ],
    //       ),
    //     ),
    //     child: Column(
    //       children: <Widget>[
    //         Padding(
    //           padding: EdgeInsets.only(top: 50),
    //         ),
    //         Text(
    //           'Language',
    //           style: TextStyle(
    //               fontWeight: FontWeight.w600,
    //               fontSize: 30.0,
    //               color: Colors.white),
    //         ),
    //         Padding(
    //           padding: EdgeInsets.only(top: 10),
    //         ),
    //         Text(
    //           'Choose your preference',
    //           style: TextStyle(fontSize: 15.0, color: Colors.white),
    //         ),
    //         Padding(
    //           padding: EdgeInsets.only(top: 100),
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Container(
    //               decoration: BoxDecoration(
    //                   border: Border(
    //                       bottom:
    //                           BorderSide(width: 4, color: Colors.redAccent))),
    //               child: SizedBox(
    //                 width: 150,
    //                 height: 150,
    //                 child: FlatButton(
    //                     color: Colors.white,
    //                     onPressed: () async {
    //                       await allTranslations.setNewLanguage("en");
    //                       setState(() {});
    //                       Navigator.pushNamed(context, "/auth");
    //                     },
    //                     child: Column(
    //                       children: <Widget>[
    //                         Text(
    //                           "A",
    //                           style: TextStyle(
    //                               color: Colors.orangeAccent,
    //                               fontSize: 100.0,
    //                               fontWeight: FontWeight.w600),
    //                         )
    //                       ],
    //                     )),
    //               ),
    //             ),
    //             Container(
    //               decoration: BoxDecoration(
    //                   border: Border(
    //                       bottom:
    //                           BorderSide(width: 4, color: Colors.redAccent))),
    //               child: SizedBox(
    //                 width: 150,
    //                 height: 150,
    //                 child: FlatButton(
    //                     color: Colors.white,
    //                     onPressed: () async {
    //                       await allTranslations.setNewLanguage("ta");
    //                       setState(() {});
    //                       Navigator.pushNamed(context, "/auth");
    //                     },
    //                     child: Column(
    //                       children: <Widget>[
    //                         Text(
    //                           "அ",
    //                           style: TextStyle(
    //                             color: Colors.orangeAccent,
    //                             fontSize: 100.0,
    //                           ),
    //                         )
    //                       ],
    //                     )),
    //               ),
    //             ),
    //           ],
    //         ),
    //         Padding(
    //           padding: EdgeInsets.only(top: 20),
    //         ),
    //         Container(
    //           decoration: BoxDecoration(
    //               border: Border(
    //                   bottom: BorderSide(width: 4, color: Colors.redAccent))),
    //           child: SizedBox(
    //             height: 140,
    //             child: FlatButton(
    //                 color: Colors.white,
    //                 onPressed: () async {
    //                   await allTranslations.setNewLanguage("te");
    //                   setState(() {});
    //                   Navigator.pushNamed(context, "/auth");
    //                 },
    //                 child: Column(
    //                   children: <Widget>[
    //                     Text(
    //                       "Aஅ",
    //                       style: TextStyle(
    //                         color: Colors.orange,
    //                         fontSize: 100.0,
    //                       ),
    //                     ),
    //                   ],
    //                 )),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ));
  }
}
