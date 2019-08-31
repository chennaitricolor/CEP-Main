import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_chennai/model/user.dart';
import 'package:hello_chennai/utils/api.dart';
import 'package:hello_chennai/utils/Strings.dart';

API api = new API();

class ChatEnvironment extends StatelessWidget{
   User currentUser;
   bool isCityChat;
  String userZone;
   ChatEnvironment(User user,bool isCityChat, String userZone){
    this.currentUser = user;
    this.isCityChat = isCityChat;
    this.userZone = userZone;
  }
   String getMessageBucket(){
     return (this.isCityChat) ? Strings.CHENNAI_CITY_TOPIC: userZone;
   }

  final TextEditingController _chatController = new TextEditingController();

   String getUserSentBy(){
     return "${currentUser.userName} (#${currentUser.userAutoId})";
   }
  void _handleSubmit(String text) {
    _chatController.clear();
    String data = currentUser.userName;
    if(text != '' && data!=null) {
      Firestore.instance.collection('chat-messages')
          .document(getMessageBucket())
          .collection('messages')
          .document()
          .setData({
          'message': text,
          'sentBy': getUserSentBy(),
          'sentAt': DateTime.now(),
          'sentId': currentUser.userId
        });
      api.messageAdded(currentUser.userName, text, getMessageBucket());
    }else {
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
                keyboardType: TextInputType.text,
                maxLines: null,
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


