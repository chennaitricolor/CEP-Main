import 'package:flutter/material.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/model/userapps.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';

SharedPrefs _sharedPrefs = new SharedPrefs();
Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('userapps');
CollectionReference collectionRef2 = db.collection('users');

class AppDetailScreen extends StatefulWidget {
  Apps app;

  AppDetailScreen({this.app});

  @override
  AppDetailState createState() => new AppDetailState(app: this.app);
}

class AppDetailState extends State<AppDetailScreen> {
  Apps app;
  UserApps userApps;
  User currentUser;
  String documentId;
  String userId;
  bool installed = false;

  AppDetailState({this.app});

  installApp() {
    installed = false;
    getMyInfo(true);
  }

  getMyInfo(bool isAddApp) {
    collectionRef2
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents;
      for (DocumentSnapshot doc in docs) {
        User user = new User.fromSnapShot(doc);
        currentUser = user;
      }
      fetchExistingUserApps(isAddApp);
    });
  }

  fetchExistingUserApps(bool isAddApp){
    collectionRef.where("user_id", isEqualTo: userId).snapshots().listen((QuerySnapshot snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents;
      for (DocumentSnapshot doc in docs) {
        documentId = doc.documentID;
        userApps = UserApps.fromSnapShot(doc);
      }
      if(isAddApp){
        addApp();
      } else {
        if(userApps != null && userApps.apps != null){
          if(userApps.apps.contains(app.appId)){
            setState(() {
              installed = true;
            });
          }
        }
      }
    });
  }

  addApp() {
    if(installed == false){
      if(userApps == null){
        userApps = new UserApps(userId);
        userApps.apps = new List();
        userApps.layout = new List();
      }
      userApps.apps.add(app.appId);
      userApps.layout.add(app.appId);
      if(documentId != null){
        collectionRef
            .document(documentId)
            .updateData(userApps.toJson())
            .catchError((e) {
          print(e);
        });
      } else {
        collectionRef.document().setData(userApps.toJson()).catchError((e) {
          print(e);
        });
      }
      setState(() {
        installed = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _sharedPrefs.getApplicationSavedInformation("loggedinuser").then((val) {
      userId = val;
      getMyInfo(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 224, 224, 224),
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          centerTitle: false,
          title: const Text('Namma App Kadai'),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 40.0, right: 10.0, left: 10.0),
              child: Container(
                  height: 500.0,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Image.network(
                            app.appIconUrl,
                            width: 50,
                          ),
                          title: Text(app.appName,
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold)),
                          subtitle: Text(app.appUrl,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal)),
                        ),
                        elevation: 4.0,
                      ),
                      Card(
                          elevation: 4.0,
                          child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text("Launch Date:",
                                        style: TextStyle(fontSize: 14.0)),
                                    subtitle: Text(
                                        app.appLaunchDate.toLocal().toString(),
                                        style: TextStyle(fontSize: 12.0)),
                                  ),
                                ],
                              ))),
                      Card(
                          elevation: 4.0,
                          child: Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(app.appDesc,
                                        style: TextStyle(fontSize: 18.0)),
                                  ),
                                ],
                              ))),
                      Expanded(child: Container()),
                      (installed == false) ?
                      FlatButton(
                        color: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () {
                          installApp();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 98.0),
                          child: Text(
                            'Install',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ) : FlatButton(
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () {
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 98.0),
                          child: Text(
                            'Installed',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
