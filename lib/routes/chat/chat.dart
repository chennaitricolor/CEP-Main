import 'package:flutter/material.dart';
import 'package:namma_chennai/model/user.dart';
import 'chatscreen.dart';

class Chat extends StatefulWidget {
  final bool isCityChat;
  User currentUser;
  Chat({Key key, this.isCityChat, this.currentUser}) : super(key: key);

  @override
  State createState() => new ChatState();
}

class ChatState extends State<Chat>{

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

