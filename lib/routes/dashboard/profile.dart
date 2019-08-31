import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_chennai/locale/all_translations.dart';
import 'package:hello_chennai/model/user.dart';
import 'package:hello_chennai/model/orgs.dart';
import 'package:hello_chennai/utils/shared_prefs.dart';
import 'package:hello_chennai/utils/globals.dart';
import 'package:hello_chennai/utils/Strings.dart';

SharedPrefs _sharedPrefs = new SharedPrefs();
Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('users');
CollectionReference collectionRef2 = db.collection('orgs');

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => new ProfileState();
}

class ProfileState extends State<Profile> {
  User currentUser;
  String userId;
  List<Orgs> currentOrgs = new List();
  List<Widget> listW = new List();
  bool isLoaded = false;

  showNGOForm() {
    Navigator.pushNamed(context, "/ngoform");
  }

  Future<QuerySnapshot> getMyInfo() async {
    return fireCollections.getUserInfoByUserId(userId);
  }

  Future<QuerySnapshot> getOrgInfo() async {
    return fireCollections.getUserOrgsByUserId(userId);
  }

  bool isProfileComplete() {
    var val =  !(currentUser.userName == null || currentUser.userGender == null ||
     currentUser.userDob == null || currentUser.userWard == null);
     return val;
  }

  renderObjects() {
    listW = [];
    listW.add(Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 5, left: 10),
        child: Text(
          allTranslations.text('translation_23'),
          style: TextStyle(fontSize: 12),
        ),
      ),
    ));

    for (Orgs org in currentOrgs) {
      listW.add(Card(
        margin: EdgeInsets.all(2),
        child: InkWell(
          child: ListTile(
            title: Text(org.orgName),
            subtitle: Text(org.orgType.substring(8)),
            trailing: Icon(
              Icons.report_problem,
              color: Colors.orange,
            ),
          ),
        ),
      ));
    }

    listW.add(Card(
      margin: EdgeInsets.all(2),
      child: InkWell(
        child: ListTile(
          onTap: () {
            showNGOForm();
          },
          title: Text(
            allTranslations.text('translation_24'),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.add_box,
                    size: 18,
                    color: Colors.blue,
                  ),
                ),
                TextSpan(
                  text: " Add",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    ));

    setState(() {
      this.listW = listW;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fireCollections.getLoggedInUserId().then((val) {
      setState(() {
        userId = val;
      });
      refresh();
    });
  }

  refresh() async {
    currentOrgs = new List();
    List<Future<QuerySnapshot>> futures = [getMyInfo(), getOrgInfo()];
    List<QuerySnapshot> result = await Future.wait(futures);
    List<DocumentSnapshot> infoDocs = result[0].documents;
    for (DocumentSnapshot doc in infoDocs) {
      currentUser = new User.fromSnapShot(doc);
    }
    List<DocumentSnapshot> orgDocs = result[1].documents;
    for (DocumentSnapshot doc in orgDocs) {
      Orgs org = new Orgs.fromSnapShot(doc);
      currentOrgs.add(org);
    }
    renderObjects();
  }

  @override
  Widget build(BuildContext context) {
    bool isProfileCompleted = isProfileComplete();
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color.fromARGB(150, 224, 224, 224),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: false,
          title: Text(allTranslations.text('translation_21')),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              isProfileCompleted ? Container() :
               Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  color: Colors.orange,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.warning,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: Strings.INCOMPLETE_PROFILE,
                            style: TextStyle(color: Colors.white),
                          ),
                          WidgetSpan(
                            child: Icon(
                              Icons.play_circle_filled,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              isLoaded
                  ? SingleChildScrollView(
                      child: Stack(
                      children: <Widget>[
                        Container(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, bottom: 5, left: 10),
                                      child: Text(
                                        Strings.APPLICATION_LANGUAGE,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      title: Text(
                                        Strings.CHANGE_LANGUAGE,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        print(Strings.CHANGE_LANGUAGE);
                                        operations
                                            .showLanguageSelection(context)
                                            .then((language) {
                                          setState(() {});
                                          languageCode =
                                              allTranslations.currentLanguage;
                                          Navigator.of(context).pop();
                                          refresh();
                                        });
                                        // streamController.add("English"+DateTime.now().toString());
                                      },
                                      trailing: RichText(
                                        text: TextSpan(
                                          text:
                                              "${allTranslations.text('language')}   ",
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                  Icons.play_circle_filled,
                                                  size: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // subtitle: Text(
                                      //     "${allTranslations.text('language')}"),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, bottom: 5, left: 10),
                                      child: Text(
                                        Strings.PERSONAL_INFORMATION,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      title: Text(
                                        Strings.MY_PROFILE,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(context, "/form")
                                            .then((r) {
                                          refresh();
                                        });
                                      },
                                      trailing: RichText(
                                        text: TextSpan(
                                          text: currentUser.userName + "  ",
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                  Icons.play_circle_filled,
                                                  size: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // subtitle: Text(
                                      //     "${allTranslations.text('language')}"),
                                    ),
                                  ),
                                  // Card(
                                  //   margin: EdgeInsets.only(
                                  //       top: 5, right: 5, left: 5, bottom: 0),
                                  //   color: Colors.white,
                                  //   child: ListTile(
                                  //     title: Text(
                                  //       currentUser.userName,
                                  //       style: TextStyle(fontSize: 22),
                                  //     ),
                                  //     trailing: InkWell(
                                  //       onTap: () {
                                  //         Navigator.pushNamed(context, "/form")
                                  //             .then((r) {
                                  //           refresh();
                                  //         });
                                  //       },
                                  //       child: Padding(
                                  //         padding: EdgeInsets.all(0),
                                  //         child: Icon(
                                  //           Icons.edit,
                                  //           color: Colors.grey,
                                  //           size: 25,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     subtitle: Text(
                                  //         "+91-" + currentUser.userPhoneNumber),
                                  //   ),
                                  // ),
                                  Column(
                                    children: listW,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Logged in as",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(3),
                                        ),
                                        Text(
                                          "${currentUser.userPhoneNumber}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(3),
                                        ),
                                        Text(
                                          "v1.0",
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        FlatButton(
                                          color: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            fireCollections
                                                .removeLoggedInUserId();
                                            Navigator.pushNamedAndRemoveUntil(
                                                context, '/auth', (_) => false);
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                allTranslations
                                                    .text('translation_5'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // Text(
                                              //   allTranslations
                                              //       .text('translation_6'),
                                              //   style: TextStyle(
                                              //     color: Colors.white,
                                              //     fontSize: 12.0,
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //     margin: EdgeInsets.only(
                                  //         top: 10.0, left: 10, right: 10),
                                  //     child: ),
                                  // Padding(
                                  //   padding: EdgeInsets.only(top: 10, bottom: 10),
                                  //   child: Center(
                                  //     child: Text(
                                  //       "v1.0",
                                  //       style: TextStyle(color: Colors.black54),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              )),
                        )
                      ],
                    ))
                  : Center(
                      child: CircularProgressIndicator(),
                    )
            ],
          ),
        ));
  }
}
