import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_chennai/locale/all_translations.dart';
import 'package:hello_chennai/model/apps.dart';
import 'package:hello_chennai/model/user.dart';
import 'package:hello_chennai/model/userapps.dart';
import 'package:hello_chennai/routes/dashboard/myapps.dart';
import 'package:hello_chennai/utils/globals.dart';

class AllApps extends StatefulWidget {
  @override
  AllAppsState createState() => new AllAppsState();
}

class AllAppsState extends State<AllApps> {
  List<Apps> apps = new List();
  List<Apps> allApps;
  MyAppsState myAppsState = new MyAppsState();
  List<String> installedAppIds = new List();
  String userId;
  List<Apps> searchResult = [];
  Widget searchResultWidgetList;
  String searchTerm = '';
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
        buildSearchResultWidget();
      });
    });
  }

  buildSearchResultWidget() {
    Widget filteredListView = ListView.separated(
        itemCount: this.allApps.length,
        separatorBuilder: (context, index) => Divider(
              color: Colors.grey,
              height: 0.1,
            ),
        itemBuilder: (BuildContext ctxt, int index) {
          return (this.searchTerm != null &&
                  this
                          .allApps[index]
                          .appName[languageCode]
                          .toString()
                          .toLowerCase()
                          .indexOf(this.searchTerm) >=
                      0)
              ? Column(
                  children: <Widget>[
                    ListTile(
                      leading: this.allApps[index].appIconUrl.indexOf("http") >=
                              0
                          ? Image.network(
                              this.allApps[index].appIconUrl,
                              width: 50,
                            )
                          : Image(
                              image: AssetImage(this.allApps[index].appIconUrl),
                              width: 50.0,
                            ),
                      title: Text(this.allApps[index].appName[languageCode]),
                      subtitle: InkWell(
                        child: Text(this.allApps[index].appLaunchDate),
                      ),
                      trailing: installedAppIds != null &&
                              installedAppIds
                                  .contains(this.allApps[index].appId)
                          ? FlatButton.icon(
                              onPressed: () {
                                operations
                                    .removeApp(userApps, this.allApps[index],
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
                                    .installApp(userApps, this.allApps[index],
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
                        subtitle:
                            Text(this.allApps[index].appDesc[languageCode]),
                      ),
                    )
                  ],
                )
              : new Container();
        });
    setState(() {
      isLoading = false;
      this.searchResultWidgetList = filteredListView;
    });
  }

  Widget searchCard() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.search),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        this.searchTerm = value;
                      });
                      buildSearchResultWidget();
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: allTranslations.text('translation_19')),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: false,
        title: Text(allTranslations.text('translation_16')),
      ),
      body: Column(children: <Widget>[
        Stack(children: <Widget>[
          Container(
            height: 80,
            color: Colors.blue,
          ),
          searchCard()
        ]),
        Flexible(
          child: !isLoading
              ? this.searchResultWidgetList
              : Center(
                  child: CircularProgressIndicator(),
                ),
        )
      ]),
    );
  }
}
