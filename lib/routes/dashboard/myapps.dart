import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/model/userapps.dart';
import 'package:namma_chennai/routes/dashboard/home.dart';
import 'package:namma_chennai/routes/webview/webview.dart';
import 'package:namma_chennai/utils/default_data.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';
import 'package:carousel_slider/carousel_slider.dart';

SharedPrefs _sharedPrefs = new SharedPrefs();
Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('userapps');
CollectionReference collectionRef2 = db.collection('users');

class MyApps extends StatefulWidget {
  @override
  MyAppsState createState() => new MyAppsState();
}

class MyAppsState extends State<MyApps> {
  List<Widget> listW = new List<Widget>();
  List<Apps> apps = new List();
  List<Map<String, String>> installedApps = new List();
  List<Map<String, String>> featuredApps;
  List<Widget> featuredAppsWidget = new List<Widget>();
  String userId;

  var app;
  UserApps userApps;
  User currentUser;
  String documentId;
  bool installed = false;

  @override
  void initState() {
    super.initState();
    this.featuredApps = DefaultData.apps;
    buildDefaultApps();
    _sharedPrefs.getApplicationSavedInformation("loggedinuser").then((val) {
      userId = val;
      getAllMyApps();
      getMyInfo(false);
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
    collectionRef
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents;
      // print("Fetch existing");
      // print(docs);
      for (DocumentSnapshot doc in docs) {
        documentId = doc.documentID;
        userApps = UserApps.fromSnapShot(doc);
      }
      if (isAddApp) {
        addApp();
      } else {
        // print("Am in else");
        // print(app);
        if (userApps != null && userApps.apps != null && app != null) {
          if (userApps.apps.contains(app["appId"])) {
            setState(() {
              installed = true;
            });
          }
        }
      }
    });
  }

  addApp() {
    // print("trying to add app");
    // print(app);
    if (installed == false) {
      if (userApps == null) {
        userApps = new UserApps(userId);
        userApps.apps = new List();
        userApps.layout = new List();
      }
      userApps.apps.add(app["appId"]);
      userApps.layout.add(app["appId"]);
      if (documentId != null) {
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
      getAllMyApps();
      Navigator.of(context).pop();
    }
  }

  removeApp(selectedApp) {
    // selectedApp
    List<String> updatedList = [];
    userApps.apps.forEach((uApp) {
      if (selectedApp["appId"] != uApp) {
        updatedList.add(uApp);
      }
    });
    // print(updatedList);
    userApps.apps = updatedList;
    collectionRef
        .document(documentId)
        .updateData(userApps.toJson())
        .then((onValue) {
      getAllMyApps();
      Navigator.of(context).pop();
    }).catchError((e) {
      print(e);
    });
  }

  buildDefaultApps() {
    this.featuredApps.forEach((fApp) {
      this.featuredAppsWidget.add(
            Flexible(
                fit: FlexFit.tight,
                child: InkWell(
                  onTap: () {
                    showAppSelection(fApp);
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Image(
                            image: AssetImage(fApp["appIconUrl"]),
                            width: 60.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                          ),
                          Text(
                            fApp["appName"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      )),
                )),
          );
    });
  }

  showAppSelection(app) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                ListTile(
                  leading: Image(
                    image: AssetImage(app["appIconUrl"]),
                    width: 60.0,
                  ),
                  // Image.network(
                  //   app["appIconUrl"],
                  //   width: 50,
                  // ),
                  title: Text(app["appName"]),
                  subtitle: InkWell(
                    child: Text(app["appLaunchDate"]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: ListTile(
                    subtitle: Text(app["appDesc"]),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child:
                      (userApps != null && userApps.apps.contains(app["appId"]))
                          ? FlatButton(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () {
                                removeApp(app);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 0.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Remove',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : FlatButton(
                              color: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () {
                                installApp(app);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 0.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Install',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'This will add to your home screen',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                ),
                Padding(
                  padding: EdgeInsets.all(40),
                ),
              ],
            ),
          );
        });
  }

  getAllMyApps() {
    collectionRef
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents;
      for (DocumentSnapshot doc in docs) {
        // print(doc);
        List<dynamic> appIds = doc["apps"];
        // print(appIds);
        installedApps = new List();
        for (var fApp in DefaultData.apps) {
          // print(fApp["appId"]);
          if (appIds.contains(fApp["appId"])) {
            // print(fApp);
            installedApps.add(fApp);
          }
        }
        renderObjects();
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

  renderObjects() {
    // listW.add(ListTile(
    //   title: Text("My Apps"),
    // ));
    // print("render obj");
    // print(installedApps);
    listW = List.generate(installedApps.length, (index) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                      url: installedApps[index]["appUrl"],
                      name: installedApps[index]["appName"])));
        },
        onLongPress: () {
          showAppSelection(installedApps[index]);
        },
        child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Image(
                  image: AssetImage(installedApps[index]["appIconUrl"]),
                  width: 60.0,
                ),
                Padding(
                  padding: EdgeInsets.all(2),
                ),
                Text(
                  installedApps[index]["appName"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ],
            )),
      );
    });

    // for (Apps app in apps) {
    //   listW.add(value)

    //   listW.add(Card(
    //     margin: EdgeInsets.all(5),
    //     child: InkWell(
    //       onTap: () {
    //         Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) =>
    //                     WebViewScreen(url: app.appUrl, name: app.appName)));
    //       },
    //       child: ListTile(
    //         leading: Image.network(
    //           app.appIconUrl,
    //           width: 50,
    //         ),
    //         title: Text(app.appName),
    //         subtitle: Text(app.appUrl),
    //         trailing: Icon(Icons.keyboard_arrow_right),
    //       ),
    //     ),
    //   ));
    // }

    setState(() {
      this.listW = listW;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _sharedPrefs.getApplicationSavedInformation("loggedinuser").then((val) {
  //     userId = val;
  //     getAllMyApps();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: false,
          title: Text('Vanakkam Raj!'),
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
                              Text(
                                "Corporation of Chennai \nwelcomes you!",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
                          "Updates & Notifications",
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
                            child: InkWell(
                              onTap: () {},
                              child: ListTile(
                                title: Text(
                                  'Have you paid your property tax yet?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                    "The last dates for payment your property tax are March 31 and September 31, every year."),
                                trailing: Icon(Icons.keyboard_arrow_right),
                              ),
                            )),
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
                            "Your micro apps",
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
                                      "You have not downloaded any apps on Namma Chennai yet.",
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
                                        navigationBar.onTap(2);
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
                              "Featured micro apps",
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
                                    "view all",
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
                    child: Row(children: this.featuredAppsWidget),
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
