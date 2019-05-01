import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChatEnvironment extends StatelessWidget{

  final TextEditingController _chatController = new TextEditingController();

  void _handleSubmit(String text) {
    _chatController.clear();
    Firestore.instance.collection('wards').document('ward-2').collection('messages')
        .document()
        .setData({ 'message': text, 'sentBy': 'author', 'sentAt': DateTime.now() });
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