import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_chennai/locale/all_translations.dart';
import 'package:hello_chennai/model/apps.dart';
import 'package:hello_chennai/model/user.dart';
import 'package:hello_chennai/model/userapps.dart';
import 'package:hello_chennai/routes/webview/webview.dart';
import 'package:hello_chennai/utils/globals.dart';
// import 'package:carousel_slider/carousel_slider.dart';

class MyApps extends StatefulWidget {
  @override
  MyAppsState createState() => new MyAppsState();
}

class MyAppsState extends State<MyApps> {
  List<Widget> listW = new List<Widget>();
  List<Apps> apps = new List();
  UserApps userAppsInfo;
  List<String> installedAppIds = new List();
  List<Apps> installedApps = new List();
  List<Apps> featuredApps = new List();
  List<Widget> featuredAppsWidget = new List<Widget>();
  String userId;

  UserApps userApps;
  User currentUser;
  String documentId;
  bool installed = false;

  @override
  void initState() {
    super.initState();

    fireCollections.getLoggedInUserId().then((val) {
      userId = val;
      getAllMyApps();
    }).then((r) {
      fireCollections
          .getUserInfoByUserId(userId)
          .then((QuerySnapshot snapshot) {
        List<DocumentSnapshot> docs = snapshot.documents;
        for (DocumentSnapshot doc in docs) {
          User user = new User.fromSnapShot(doc);
          currentUser = user;
        }
      });
    });
    // streamController.stream.listen((data) {
    //   print(data);
    // });
  }

  buildFeaturedApps() {
    this.featuredAppsWidget = [];
    this.featuredAppsWidget = List.generate(this.featuredApps.length, (index) {
      return InkWell(
        onTap: () {
          operations
              .showAppSelection(userApps, this.featuredApps[index], userId,
                  documentId, context)
              .then((r) {
            getAllMyApps();
            Navigator.of(context).pop();
          });
        },
        child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                this.featuredApps[index].appIconUrl.indexOf("http") >= 0
                    ? Image.network(
                        this.featuredApps[index].appIconUrl,
                        width: 50,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                      )
                    : Image(
                        image: AssetImage(this.featuredApps[index].appIconUrl),
                        width: 50.0,
                      ),
                Padding(
                  padding: EdgeInsets.all(2),
                ),
                Text(
                  this.featuredApps[index].appName[languageCode],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ],
            )),
      );
    });
    setState(() {
      this.featuredApps = this.featuredApps;
    });
  }

  renderObjects() {
    listW = List.generate(installedApps.length, (index) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                      url: installedApps[index].appUrl +
                          (installedApps[index].appIconUrl.indexOf("http") >= 0
                              ? "/signin.html?token=" + userId
                              : ""),
                      name: installedApps[index].appName[languageCode])));
        },
        onLongPress: () {
          operations
              .showAppSelection(
                  userApps, installedApps[index], userId, documentId, context)
              .then((r) {
            getAllMyApps();
            Navigator.of(context).pop();
          });
        },
        child: Container( 
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                installedApps[index].appIconUrl.indexOf("http") >= 0
                    ? Image.network(
                        installedApps[index].appIconUrl,
                        width: 50,
                        loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                      )
                    : Image(
                        image: AssetImage(installedApps[index].appIconUrl),
                        width: 50.0,
                      ),
                Padding(
                  padding: EdgeInsets.all(2),
                ),
                Text(
                  installedApps[index].appName[languageCode],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ],
            )),
      );
    });

    setState(() {
      this.listW = listW;
    });
  }

  getAllMyApps() {
    popupWidget.showLoading(context, allTranslations.text('translation_40'));
    fireCollections.getUserAppsByUserId(userId).then((QuerySnapshot result) {
      List<DocumentSnapshot> docs = result.documents;
      for (DocumentSnapshot doc in docs) {
        documentId = doc.documentID;
        userApps = new UserApps.fromSnapShot(doc);
        this.installedAppIds = userApps.apps;
      }
    }).then((r) {
      fireCollections.getAllApps().then((result) {
        this.featuredApps = [];
        installedApps = [];
        List<DocumentSnapshot> docs = result.documents;
        for (DocumentSnapshot doc in docs) {
          Apps app = new Apps.fromSnapShot(doc);
          if (this.installedAppIds.contains(app.appId)) {
            installedApps.add(app);
          } else {
            this.featuredApps.add(app);
          }
        }
        setState(() {
          this.listW = [];
          this.installedApps = installedApps;
        });
        popupWidget.hideLoading(context);
        buildFeaturedApps();
        renderObjects();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: false,
          title: Text(
              '${allTranslations.text('translation_7')} ${currentUser == null ? '' : currentUser.userName}!'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 100,
                    color: Colors.blue,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                    height: 150,
                    decoration: BoxDecoration(
                      // Border color
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage(
                                    'assets/images/logo/corporationofchennai.png'),
                                width: 80.0,
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              Flexible(
                                child: Text(
                                    allTranslations.text('translation_8'),
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Image(
                            image: AssetImage(
                                'assets/images/logo/carousel_bg.png'),
                            width: MediaQuery.of(context).size.width,
                          ),
                        )
                      ],
                    ),
                  ),
                  // CarouselSlider(
                  //     height: 140.0,
                  //     enlargeCenterPage: true,
                  //     items: [1].map((i) {
                  //       return Builder(
                  //         builder: (BuildContext context) {
                  //           return Container(
                  //             width: MediaQuery.of(context).size.width,
                  //             margin: EdgeInsets.symmetric(horizontal: 3.0),
                  //             decoration: BoxDecoration(
                  //               // Border color
                  //               color: Colors.white,
                  //               boxShadow: <BoxShadow>[
                  //                 BoxShadow(
                  //                   color: Colors.grey,
                  //                   offset: Offset(1.0, 1.0),
                  //                   blurRadius: 1.0,
                  //                 ),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       );
                  //     }).toList(),
                  //   ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          allTranslations.text('translation_9'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            // padding: const EdgeInsets.all(3.0),
                            decoration: new BoxDecoration(
                              border: Border(
                                left:
                                    BorderSide(width: 3.0, color: Colors.blue),
                              ),
                            ),
                            child:ListTile(
                                title: Text(
                                  allTranslations.text('translation_10'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                    allTranslations.text('translation_11')),
                              ),
                            ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      // Border color
                      color: Color.fromRGBO(158, 158, 158, 0.1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            allTranslations.text('translation_12'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            (listW.length == 0)
                                ? Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "You have not downloaded any apps on Hello Chennai yet.",
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  )
                                : new Container(),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            (listW.length != 0)
                                ? GridView.count(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    // Create a grid with 2 columns. If you change the scrollDirection to
                                    // horizontal, this would produce 2 rows.
                                    crossAxisCount: 4,
                                    // Generate 100 Widgets that display their index in the List
                                    children: listW)
                                : new Container(),
                            (listW.length == 0)
                                ? Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: InkWell(
                                      onTap: () {
                                        final BottomNavigationBar
                                            navigationBar =
                                            globalKey.currentWidget;
                                        navigationBar.onTap(1);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: new Border.all(
                                                color: Colors.blueAccent),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        width: 50,
                                        height: 50,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  )
                                : new Container(),
                          ],
                        )),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              allTranslations.text('translation_13'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            fit: FlexFit.tight,
                          ),
                          Flexible(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    final BottomNavigationBar navigationBar =
                                        globalKey.currentWidget;
                                    navigationBar.onTap(2);
                                  },
                                  child: Text(
                                    allTranslations.text('translation_18'),
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 15.0),
                                  ),
                                )),
                            fit: FlexFit.tight,
                          ),
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    // padding: const EdgeInsets.all(3.0),
                    child: GridView.count(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this would produce 2 rows.
                        crossAxisCount: 4,
                        // Generate 100 Widgets that display their index in the List
                        children: this.featuredAppsWidget),
                  ),
                ],
              ),
            ],
          ),
        ));
    // body: Column(
    //   children: listW,
    // ));
  }
}
