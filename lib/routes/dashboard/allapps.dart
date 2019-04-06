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
        documentId = doc.documentID;
        userApps = new UserApps.fromSnapShot(doc);
        installedAppIds = userApps.apps;
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
                      title: Text(this.allApps[Index].appName[languageCode]),
                      subtitle: InkWell(
                        child: Text(this.allApps[Index].appLaunchDate),
                      ),
                      trailing: installedAppIds != null &&
                              installedAppIds
                                  .contains(this.allApps[Index].appId)
                          ? FlatButton.icon(
                              onPressed: () {
                                operations
                                    .removeApp(userApps, this.allApps[Index],
                                        documentId, context)
                                    .then((r) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  refresh();
                                });
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
                                operations
                                    .installApp(userApps, this.allApps[Index],
                                        userId, documentId, context)
                                    .then((result) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  refresh();
                                });
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
                        subtitle: Text(this.allApps[Index].appDesc[languageCode]),
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
