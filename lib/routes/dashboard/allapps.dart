import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/model/userapps.dart';
import 'package:namma_chennai/routes/appdetail/appdetail.dart';
import 'package:namma_chennai/routes/dashboard/myapps.dart';
import 'package:namma_chennai/utils/default_data.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';

SharedPrefs _sharedPrefs = new SharedPrefs();
Firestore db = Firestore.instance;
CollectionReference collectionRef1 = db.collection('userapps');
CollectionReference collectionRef2 = db.collection('users');

class AllApps extends StatefulWidget {
  @override
  AllAppsState createState() => new AllAppsState();
}

class AllAppsState extends State<AllApps> {
  List<Widget> listW = new List<Widget>();
  List<Apps> apps = new List();
  List<Map<String, String>> allApps;
  MyAppsState myAppsState = new MyAppsState();
  List<String> installedAppIds = new List();
  String userId;

  var app;
  UserApps userApps;
  User currentUser;
  String documentId;
  bool installed = false;

  @override
  void initState() {
    super.initState();
    this.allApps = DefaultData.apps;
    _sharedPrefs.getApplicationSavedInformation("loggedinuser").then((val) {
      userId = val;
    });
    getAllMyApps();
    getMyInfo(false);
    // getAllApps();
  }

  getAllMyApps() {
    collectionRef1
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents;
      for (DocumentSnapshot doc in docs) {
        print(doc);
        List<dynamic> appIds = doc["apps"];
        print(appIds);
        for (var fApp in this.allApps) {
          print(fApp["appId"]);
          if (appIds.contains(fApp["appId"])) {
            // print(fApp);
            installedAppIds.add(fApp["appId"]);
          }
        }

        setState(() {
          this.installedAppIds = installedAppIds;
        });
        print(installedAppIds);
        // for (String appId in appIds) {
        //   collectionRef2
        //       .where("app_id", isEqualTo: appId)
        //       .snapshots()
        //       .listen((QuerySnapshot snapshot2) {
        //     List<DocumentSnapshot> docs2 = snapshot2.documents;
        //     for (DocumentSnapshot doc2 in docs2) {
        //       Apps app = new Apps.fromSnapShot(doc2);
        //       apps.add(app);
        //     }
        //     renderObjects();
        //   });
        // }
      }
    });
  }

  installApp(selectedApp) {
    app = selectedApp;
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

  fetchExistingUserApps(bool isAddApp) {
    collectionRef1
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents;
      print("Fetch existing");
      print(docs);
      for (DocumentSnapshot doc in docs) {
        documentId = doc.documentID;
        userApps = UserApps.fromSnapShot(doc);
      }
      print(documentId);
      if (isAddApp) {
        addApp();
      } else {
        // print("Am in else");
        // print(app);
        // if (userApps != null && userApps.apps != null && app != null) {
        //   if (userApps.apps.contains(app["appId"])) {
        //     setState(() {
        //       installed = true;
        //     });
        //   }
        // }
      }
    });
  }

  addApp() {
    print("trying to add app");
    print(app);
    print(userId);
    if (installed == false) {
      if (userApps == null) {
        userApps = new UserApps(userId);
        userApps.apps = new List();
        userApps.layout = new List();
      }
      userApps.apps.add(app["appId"]);
      userApps.layout.add(app["appId"]);
      if (documentId != null) {
        collectionRef1
            .document(documentId)
            .updateData(userApps.toJson())
            .catchError((e) {
          print(e);
        });
      } else {
        collectionRef1.document().setData(userApps.toJson()).catchError((e) {
          print(e);
        });
      }
      setState(() {
        installed = true;
      });
    }
  }

  removeApp(selectedApp) {
    // selectedApp
    print("delete app");
    print(userApps);
    List<String> updatedList = [];
    userApps.apps.forEach((uApp) {
      if (selectedApp["appId"] != uApp) {
        updatedList.add(uApp);
      }
    });
    print(updatedList);
    userApps.apps = updatedList;
    userApps.layout = updatedList;
    collectionRef1
        .document(documentId)
        .updateData(userApps.toJson())
        .then((onValue) {
      setState(() {
        this.installedAppIds = [];
      });
      getAllMyApps();
      getMyInfo(false);
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: false,
        title: Text('All Apps'),
      ),
      body: ListView.separated(
          itemCount: this.allApps.length,
          separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
                height: 0.1,
              ),
          itemBuilder: (BuildContext ctxt, int Index) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: Image(
                    image: AssetImage(this.allApps[Index]["appIconUrl"]),
                    width: 50.0,
                  ),
                  // Image.network(
                  //   this.allApps[Index][""],
                  //   width: 50,
                  // ),
                  title: Text(this.allApps[Index]["appName"]),
                  subtitle: InkWell(
                    child: Text(this.allApps[Index]["appLaunchDate"]),
                  ),
                  trailing: installedAppIds != null &&
                          installedAppIds.contains(this.allApps[Index]["appId"])
                      ? FlatButton.icon(
                          onPressed: () {
                            removeApp(this.allApps[Index]);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          label: Text(
                            "Remove",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ))
                      : FlatButton.icon(
                          onPressed: () {
                            installApp(this.allApps[Index]);
                          },
                          icon: Icon(
                            Icons.add_box,
                            color: Colors.blue,
                          ),
                          label: Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          )),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    subtitle: Text(this.allApps[Index]["appDesc"]),
                  ),
                )
              ],
            );
          }),

      // Column(
      //   children: listW,
      // )
    );
  }
}
