import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namma_chennai/locale/all_translations.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/model/userapps.dart';
import 'package:namma_chennai/utils/globals.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Apps> searchResult = [];
  List<Widget> searchResultWidget = [];
  String searchTerm = '';
  String userId;
  UserApps userApps;
  String documentId;
  List<String> installedAppIds = new List();
  List<Apps> installedApps = new List();

  @override
  void initState() {
    super.initState();
    this.searchResult = [];
    fireCollections.getLoggedInUserId().then((val) {
      userId = val;
    }).then((r) {
      getAllMyApps();
    });
  }

  getAllMyApps() {
    fireCollections.getUserAppsByUserId(userId).then((QuerySnapshot result) {
      List<DocumentSnapshot> docs = result.documents;
      for (DocumentSnapshot doc in docs) {
        documentId = doc.documentID;
        userApps = new UserApps.fromSnapShot(doc);
        this.installedAppIds = userApps.apps;
      }
    }).then((r) {
      fireCollections.getAllApps().then((result) {
        this.searchResult = [];
        installedApps = [];
        List<DocumentSnapshot> docs = result.documents;
        for (DocumentSnapshot doc in docs) {
          Apps app = new Apps.fromSnapShot(doc);
          this.searchResult.add(app);
        }
        setState(() {
          this.installedApps = installedApps;
        });
      });
    });
  }

  buildSearchResultWidget() {
    this.searchResultWidget = [];
    searchResult.forEach((result) {
      if (result.appName[languageCode]
                  .toString()
                  .toLowerCase()
                  .indexOf(searchTerm.toLowerCase()) >=
              0 ||
          searchTerm.isEmpty) {
        this.searchResultWidget.add(InkWell(
              onTap: () {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                operations
                    .showAppSelection(
                        userApps, result, userId, documentId, context)
                    .then((r) {
                  Navigator.of(context).pop();
                });
              },
              child: ListTile(
                leading: Icon(Icons.trending_up),
                title: Text(result.appName[languageCode].toString()),
              ),
            ));
      }
    });
    setState(() {
      this.searchResultWidget = this.searchResultWidget;
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
                        searchTerm = value;
                      });
                      buildSearchResultWidget();
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: allTranslations.text('translation_19')),
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
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: false,
          title: Text(allTranslations.text('translation_15')),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Stack(children: <Widget>[
              Container(
                height: 80,
                color: Colors.blue,
              ),
              searchCard()
            ]),
            Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                        searchTerm.length == 0 && searchResultWidget.length == 0
                            ? allTranslations.text('translation_20')
                            : allTranslations.text('translation_42')),
                  ),
                  Column(children: searchResultWidget)
                ],
              ),
            )
          ]),
        ));
  }
}
