import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/routes/appdetail/appdetail.dart';

Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('apps');

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
          itemCount: 10,
          separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
                height: 0.1,
              ),
          itemBuilder: (BuildContext ctxt, int Index) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: Image.network(
                    "https://www.olacabs.com/webstatic/img/favicon.ico",
                    width: 50,
                  ),
                  title: Text("Hello world"),
                  subtitle: InkWell(
                    child: Text(
                      "11.1 MB"
                    ),
                  ),
                  trailing: FlatButton.icon(onPressed: (){}, icon: Icon(Icons.arrow_downward), label: Text("Download")),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    subtitle: Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. \nLorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
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
