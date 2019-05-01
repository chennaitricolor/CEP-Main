import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/utils/globals.dart';

final SharedPrefs _sharedPrefs = new SharedPrefs();

class ChatEnvironment extends StatefulWidget{
  @override
  State createState() => new ChatEnvironmentState();

}

class ChatEnvironmentState extends State<ChatEnvironment>{
  User currentUser;
  String userId;

  @override
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
      });
    });
    // streamController.stream.listen((data) {
    //   print(data);
    // });
  }

  final TextEditingController _chatController = new TextEditingController();

  void _handleSubmit(String text) {
    _chatController.clear();
    Firestore.instance.collection('wards').document('ward-2').collection('messages')
        .document()
        .setData({ 'message': text, 'sentBy': currentUser.userName, 'sentAt': DateTime.now(), 'sentId':currentUser.userId });
  }

  Widget build(BuildContext context){
    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal:8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration.collapsed(hintText: "Start typing ..."),
                controller: _chatController,
                onSubmitted: _handleSubmit,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: ()=> _handleSubmit(_chatController.text),
              ),
            )
          ],
        ),
      ),
    );
  }
}


