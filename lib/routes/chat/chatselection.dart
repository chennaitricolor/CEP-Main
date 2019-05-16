import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/utils/globals.dart';

import 'chatscreen.dart';

class ChatSelection extends StatefulWidget{
  @override
  _ChatSelectionState createState() => _ChatSelectionState();
}

class _ChatSelectionState extends State<ChatSelection> {
  User currentUser;
  String userId;
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
        currentUser.userWard='ward-2';
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

  Widget getButtonForChat(bool isCityChat){
      String chatTitle  = (isCityChat) ? "Chennai Chat Room" : "Ward Chat Room";
    return new Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: const EdgeInsets.only(left: 15,bottom: 15),
      child: new FlatButton(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen(isCityChat: isCityChat, currentUser: currentUser)),
          );
        },
        child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child:new Text(chatTitle,  style: TextStyle(color: Colors.white,fontSize: 15)
          ),
        )
      ),
    );

  }

  Widget displayScreen(){
    return Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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

