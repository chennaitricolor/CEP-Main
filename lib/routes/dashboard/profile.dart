import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/locale/all_translations.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/model/orgs.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';
import 'package:namma_chennai/utils/globals.dart';

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

  renderObjects() {
    listW = [];
    listW.add(ListTile(
      title: Text(allTranslations.text('translation_23')),
    ));

    for (Orgs org in currentOrgs) {
      listW.add(Card(
        margin: EdgeInsets.all(2),
        child: InkWell(
          child: ListTile(
            title: Text(org.orgName),
            subtitle: Text(org.orgType.substring(8)),
            trailing: Icon(
              Icons.verified_user,
              color: Colors.green,
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
          title: Text(allTranslations.text('translation_24')),
          trailing: Icon(Icons.add_box),
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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromARGB(150, 224, 224, 224),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: false,
        title: Text(allTranslations.text('translation_21')),
      ),
      body: isLoaded
          ? SingleChildScrollView(
              child: Stack(
              children: <Widget>[
                Container(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Card(
                            margin: EdgeInsets.only(
                                top: 5, right: 5, left: 5, bottom: 0),
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                currentUser.userName,
                                style: TextStyle(fontSize: 22),
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, "/form")
                                      .then((r) {
                                    refresh();
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                ),
                              ),
                              subtitle:
                                  Text("+91-" + currentUser.userPhoneNumber),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              print("Change Language");
                              operations
                                  .showLanguageSelection(context)
                                  .then((language) {
                                setState(() {});
                                languageCode = allTranslations.currentLanguage;
                                Navigator.of(context).pop();
                                refresh();
                              });
                              // streamController.add("English"+DateTime.now().toString());
                            },
                            child: Card(
                              color: Colors.white,
                              child: ListTile(
                                title: Text(
                                  "Change Language",
                                ),
                                subtitle:
                                    Text("${allTranslations.text('language')}"),
                              ),
                            ),
                          ),
                          Column(
                            children: listW,
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: FlatButton(
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    onPressed: () {
                                      fireCollections.removeLoggedInUserId();
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, '/auth', (_) => false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 12.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            allTranslations.text('translation_5'),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            allTranslations.text('translation_6'),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Center(
                              child: Text(
                                "v1.0",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          )
                        ],
                      )),
                )
              ],
            ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
