import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/routes/appdetail/appdetail.dart';
import 'package:namma_chennai/utils/default_data.dart';

Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('apps');

class AllApps extends StatefulWidget {
  @override
  AllAppsState createState() => new AllAppsState();
}

class AllAppsState extends State<AllApps> {
  List<Widget> listW = new List<Widget>();
  List<Apps> apps = new List();
  List<Map<String, String>> allApps;

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
      title: Text("All Apps"),
    ));

    for (Apps app in apps) {
      listW.add(Card(
        margin: EdgeInsets.all(5),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AppDetailScreen(app: app)));
          },
          child: ListTile(
            leading: Image.network(
              app.appIconUrl,
              width: 50,
            ),
            title: Text(app.appName),
            subtitle: Text(app.appUrl),
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
    this.allApps = DefaultData.apps;
    // getAllApps();
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
                  trailing: FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_box,
                        color: Colors.blue,
                      ),
                      label: Text(
                        "Add",
                        style: TextStyle(color: Colors.blue,),
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
