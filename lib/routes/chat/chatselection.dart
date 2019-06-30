import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/utils/globals.dart';

import 'chat.dart';

class ChatSelection extends StatefulWidget {
  @override
  _ChatSelectionState createState() => _ChatSelectionState();
}

class _ChatSelectionState extends State<ChatSelection> {
  User currentUser;
  String userId;
  String userZone;
  bool _isLoading = true;

  void initState() {
    super.initState();
    fireCollections.getLoggedInUserId().then((val) {
      userId = val;
    }).then((r) {
      fireCollections
          .getUserInfoByUserId(userId)
          .then((QuerySnapshot snapshot) {
        List<DocumentSnapshot> docs = snapshot.documents;
        for (DocumentSnapshot doc in docs) {
          User user = new User.fromSnapShot(doc);
          currentUser = user;

        }
        //should be removed when user ward details are added.
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  Widget _loadingView() {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  String getUSerZone(String zoneRawString){
    String match;
    RegExp exp = new RegExp(r"(Zone \d* (\w*))");
    Iterable<Match> matches = exp.allMatches(zoneRawString);
    for (Match m in matches) {
      match = m.group(2);
    }
    return match;
  }

  Widget getButtonForChat(bool isCityChat) {
    userZone = getUSerZone(currentUser.userZone);
    String chatTitle = (isCityChat) ? "Chennai Chat Room" : userZone+" Zone Room";
    return new Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: const EdgeInsets.only(bottom: 15),
      child: new FlatButton(
          color: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Chat(isCityChat: isCityChat, currentUser: currentUser, userZone : userZone,)),
            );
          },
          child: new Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: new Text(chatTitle,
                style: TextStyle(color: Colors.white, fontSize: 15)),
          )),
    );
  }

  Widget displayScreen() {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.chat,
          color: Colors.grey,
          size: 180.0,
        ),
        SizedBox(
          height: 20,
        ),
        getButtonForChat(true),
        getButtonForChat(false)
      ],
     )
   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text('Select Chat Room')),
      body: (_isLoading) ? _loadingView() : displayScreen(),
    );
  }
}



