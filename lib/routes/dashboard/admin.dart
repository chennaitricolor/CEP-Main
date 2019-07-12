import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:namma_chennai/locale/all_translations.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/model/userapps.dart';
import 'package:namma_chennai/routes/dashboard/myapps.dart';
import 'package:namma_chennai/utils/globals.dart';

class Admin extends StatefulWidget {
  @override
  AdminState createState() => new AdminState();
}

class AdminState extends State<Admin> {
  List<Widget> pending = [];
  List<Widget> approved = [];
  List<Widget> rejected = [];

  AdminState() {
    // this.buildPending();
  }

  @override
  void initState() {
    super.initState();
    // this.buildPending();
  }

  buildPending() {
    pending.add(Card(
      child: ListTile(
          onTap: () {},
          title: Text(
            "Chennai Trekkers Club",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Approval Pending",
            style: TextStyle(
                color: Colors.orangeAccent, fontWeight: FontWeight.bold),
          ),
          trailing: RichText(
            text: TextSpan(
              text: 'View ',
              style: DefaultTextStyle.of(context).style,
              children: [
                WidgetSpan(
                  child: Icon(Icons.play_circle_filled, size: 16),
                ),
              ],
            ),
          )),
    ));
    setState(() {
      this.pending = pending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color.fromARGB(150, 224, 224, 224),
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.yellow,
            tabs: [
              Tab(
                text: "Pending",
              ),
              Tab(
                text: "Approved",
              ),
              Tab(
                text: "Rejected",
              ),
            ],
          ),
          title: Text('Admin | Orgs Control'),
        ),
        body: TabBarView(
          children: [
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5, left: 10),
                    child: Text(
                      "ORGANISATIONS",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                      onTap: () {},
                      title: Text(
                        "Chennai Trekkers Club",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Approval Pending",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: RichText(
                        text: TextSpan(
                          text: 'View ',
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.play_circle_filled, size: 16),
                            ),
                          ],
                        ),
                      )),
                ),
                Card(
                  child: ListTile(
                      onTap: () {},
                      title: Text(
                        "Chennai Trekkers Club",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Approval Pending",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: RichText(
                        text: TextSpan(
                          text: 'View ',
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.play_circle_filled, size: 16),
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5, left: 10),
                    child: Text(
                      "ORGANISATIONS",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                      onTap: () {},
                      title: Text(
                        "Chennai Trekkers Club",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: 'Approved ',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: RichText(
                        text: TextSpan(
                          text: 'View ',
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.play_circle_filled, size: 16),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5, left: 10),
                    child: Text(
                      "ORGANISATIONS",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                      onTap: () {},
                      title: Text(
                        "Chennai Trekkers Club",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Rejected",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      trailing: RichText(
                        text: TextSpan(
                          text: 'View ',
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.play_circle_filled, size: 16),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
