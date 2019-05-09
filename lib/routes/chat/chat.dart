import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/utils/globals.dart';
import 'chatscreen.dart';

class Chat extends StatefulWidget {
  @override
  State createState() => new ChatState();
}

class ChatState extends State<Chat>{
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
        currentUser.userWard='ward-2';

      });
    });
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
       child: ChatScreen(currentUser: currentUser),
       decoration: new BoxDecoration(
          image: new DecorationImage(
          image: new AssetImage("assets/images/apps/chat-background.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      )
    );
  }
}

