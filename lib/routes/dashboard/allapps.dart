import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/routes/appdetail/appdetail.dart';

Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('allapps');

class AllApps extends StatefulWidget {
  @override
  AllAppsState createState() => new AllAppsState();
}

class AllAppsState extends State<AllApps> {
  List<Widget> listW = new List<Widget>();
  List<Apps> apps = new List();

  getAllApps() {
    collectionRef.snapshots().listen((QuerySnapshot snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents;
      for (DocumentSnapshot doc in docs) {
        Apps app = new Apps.fromSnapShot(doc);
        apps.add(app);
      }
      renderObjects();
    });
  }

  renderObjects() {
    listW.add(ListTile(
      title: Text("Top Apps"),
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
    getAllApps();
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
