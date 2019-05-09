import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/user.dart';

class ChatEnvironment extends StatelessWidget{
  User currentUser;

  ChatEnvironment(User user){
    this.currentUser = user;
  }

  final TextEditingController _chatController = new TextEditingController();

  void _handleSubmit(String text) {
    _chatController.clear();
    String data = currentUser.userName;
    if(text != '' && data!=null) {
      Firestore.instance.collection('wards')
          .document(currentUser.userWard)
          .collection('messages')
          .document()
          .setData({
              'message': text,
              'sentBy': currentUser.userName,
              'sentAt': DateTime.now(),
              'sentId': currentUser.userId
            });
      } else {
      debugPrint('########### something wrong $text $data');
    }
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


