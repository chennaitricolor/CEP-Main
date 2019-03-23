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
    Navigator.pushNamed(context, "/ngoform");
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
      title: Text("Your Organisations"),
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
          title: Text("Add Organisation"),
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
        backgroundColor: Color.fromARGB(150, 224, 224, 224),
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
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Card(
                              color: Colors.white,
                              child: ListTile(
                                  title: Text(
                                    currentUser.userName,
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  trailing: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, "/form");
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text("+91-"+currentUser.userPhoneNumber),
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
                                        _sharedPrefs
                                            .removeApplicationSavedInformation(
                                                "loggedinuser");
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, '/auth', (_) => false);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 12.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'LOGOUT',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'This action logs you out',
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
                              padding: EdgeInsets.only(top: 10),
                              child: Center(
                              child: Text(
                                "v1.0",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),)
                          ],
                        )),
                  )
                : Center(
                  child: CircularProgressIndicator(),
                ),
          ],
        ));
  }
}
