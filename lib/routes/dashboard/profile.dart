import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/model/orgs.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';

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
    Navigator.pushNamed(context, "/form");
  }

  Future<QuerySnapshot> getMyInfo() async {
    return collectionRef.where("user_id", isEqualTo: userId).getDocuments();
  }

  Future<QuerySnapshot> getOrgInfo() async {
    return collectionRef2.where("user_id", isEqualTo: userId).getDocuments();
  }

  renderObjects() {
    print("I am gonna render");
    listW.add(ListTile(
      title: Text("My Orgs"),
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
          title: Text("Add new Org"),
          trailing: Icon(Icons.add_box),
        ),
      ),
    ));

    setState(() {
      print("it is loaded");
      print(currentUser);
      this.listW = listW;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _sharedPrefs
        .getApplicationSavedInformation("loggedinuser")
        .then((val) async {
      setState(() {
        userId = val;
      });
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
      // getMyInfo();
      // getOrgInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.black12,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: false,
          title: Text('My Profile'),
        ),
        body: Stack(
          children: <Widget>[
            isLoaded
                ? Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .02,
                        right: 10.0,
                        left: 10.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Card(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: ListTile(
                                  title: Text(
                                    currentUser.userName,
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  trailing: Icon(
                                    Icons.person_pin_circle,
                                    color: Colors.green,
                                  ),
                                  subtitle: Text(currentUser.userPhoneNumber +
                                      "\nMember since: " +
                                      currentUser.userCreatedOn
                                          .toLocal()
                                          .toString()
                                          .substring(
                                              0,
                                              currentUser.userCreatedOn
                                                      .toLocal()
                                                      .toString()
                                                      .length -
                                                  7)),
                                ),
                              ),
                              elevation: 4.0,
                            ),
                            Column(
                              children: listW,
                            ),
                            Expanded(child: Container()),
                            FlatButton(
                              color: Colors.red,
                              onPressed: () {
                                _sharedPrefs.removeApplicationSavedInformation(
                                    "loggedinuser");
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/auth', (_) => false);
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18.0, horizontal: 98.0),
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        )),
                  )
                : Container(),
          ],
        ));
  }
}
