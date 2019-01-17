import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/routes/appdetail/appdetail.dart';

Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('myapps');
CollectionReference collectionRef2 = db.collection('allapps');

class MyApps extends StatefulWidget {
  @override
  MyAppsState createState() => new MyAppsState();
}

class MyAppsState extends State<MyApps> {
  List<Widget> listW = new List<Widget>();
  List<Apps> apps = new List();

  getAllMyApps() {
    // TO DO search using user id
    collectionRef.snapshots().listen((QuerySnapshot snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents;
      for (DocumentSnapshot doc in docs) {
        collectionRef2.where("app_id", isEqualTo: doc["app_id"])
        .snapshots().listen((QuerySnapshot snapshot2) {
          List<DocumentSnapshot> docs2 = snapshot2.documents;
          for (DocumentSnapshot doc2 in docs2) {
            Apps app = new Apps.fromSnapShot(doc2);
            apps.add(app);
          }
          renderObjects();
        });
      }
    });
  }

  renderObjects() {
    listW.add(ListTile(
      title: Text("My Apps"),
    ));

    for (Apps app in apps) {
      listW.add(Card(
        margin: EdgeInsets.all(5),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AppDetailScreen(app: app)));
          },
          child: ListTile(
            leading: Image.network(
              app.iconUrl,
              width: 50,
            ),
            title: Text(app.name),
            subtitle: Text(app.link),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ));
    }

    setState(() {
      this.listW = listW;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllMyApps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          centerTitle: false,
          title: Text('Namma App Kadai'),
        ),
        body: Column(
          children: listW,
        ));
  }
}
