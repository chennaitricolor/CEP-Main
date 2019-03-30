import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/model/userapps.dart';
import 'package:namma_chennai/routes/dashboard/myapps.dart';
import 'package:namma_chennai/utils/globals.dart';

class AllApps extends StatefulWidget {
  @override
  AllAppsState createState() => new AllAppsState();
}

class AllAppsState extends State<AllApps> {
  List<Widget> listW = new List<Widget>();
  List<Apps> apps = new List();
  List<Apps> allApps;
  MyAppsState myAppsState = new MyAppsState();
  List<String> installedAppIds = new List();
  String userId;
  bool isLoading = true;

  var app;
  UserApps userApps;
  User currentUser;
  String documentId;
  bool installed = false;

  @override
  void initState() {
    super.initState();
    // this.allApps = DefaultData.apps;

    fireCollections.getLoggedInUserId().then((val) {
      userId = val;
    }).then((r) {
      refresh();
    });
  }

  refresh() {
    // Collecting user apps and extracting installed apps ids
    fireCollections.getUserAppsByUserId(userId).then((QuerySnapshot snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents;
      for (DocumentSnapshot doc in docs) {
        print("Iteration doc");
        UserApps userAppInfo = UserApps.fromSnapShot(doc);
        installedAppIds = userAppInfo.apps;
      }
      setState(() {
        this.installedAppIds = installedAppIds;
      });
    }).then((r) {
      // Collecting all apps available in the store
      fireCollections.getAllApps().then((QuerySnapshot snapshot) {
        List<DocumentSnapshot> docs = snapshot.documents;
        allApps = [];
        for (DocumentSnapshot doc in docs) {
          Apps app = Apps.fromSnapShot(doc);
          allApps.add(app);
        }
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  installApp(selectedApp) {
    app = selectedApp;
    installed = false;
    getMyInfo(true);
  }

  getMyInfo(bool isAddApp) {
    fireCollections.getUserInfoByUserId(userId)
        .then((QuerySnapshot snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents;
      for (DocumentSnapshot doc in docs) {
        User user = new User.fromSnapShot(doc);
        currentUser = user;
      }
      fetchExistingUserApps(isAddApp);
    });
  }

  fetchExistingUserApps(bool isAddApp) {
    fireCollections.getUserAppsByUserId(userId).then((QuerySnapshot snapshot) {
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
        fireCollections
            .updateUserAppsByDocumentId(documentId, userApps)
            .catchError((e) {
          popupWidget.show(context, e);
        });
      } else {
        fireCollections.assignUserAppToUserId(userApps).catchError((e) {
          popupWidget.show(context, e);
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
    userApps = new UserApps(userId);
    List<String> updatedList = [];
    installedAppIds.forEach((iAppId) {
      if (selectedApp["appId"] != iAppId) {
        updatedList.add(iAppId);
      }
    });
    print(updatedList);
    userApps.apps = updatedList;
    userApps.layout = updatedList;
    print("doc id");
    print(documentId);
    fireCollections
        .updateUserAppsByDocumentId(documentId, userApps)
        .then((onValue) {
      setState(() {
        this.installedAppIds = [];
      });
      // getAllMyApps();
      // getMyInfo(false);
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
      body: !isLoading
          ? ListView.separated(
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
                        image: AssetImage(this.allApps[Index].appIconUrl),
                        width: 50.0,
                      ),
                      // Image.network(
                      //   this.allApps[Index][""],
                      //   width: 50,
                      // ),
                      title: Text(this.allApps[Index].appName["en"]),
                      subtitle: InkWell(
                        child: Text(this.allApps[Index].appLaunchDate),
                      ),
                      trailing: installedAppIds != null &&
                              installedAppIds
                                  .contains(this.allApps[Index].appId)
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
                        subtitle: Text(this.allApps[Index].appDesc["en"]),
                      ),
                    )
                  ],
                );
              })
          : Center(
              child: CircularProgressIndicator(),
            ),

      // Column(
      //   children: listW,
      // )
    );
  }
}
