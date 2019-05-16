import 'package:flutter/material.dart';
import 'chatmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatenvironement.dart';
import 'Record.dart';
import 'package:namma_chennai/model/user.dart';

class ChatScreen extends StatefulWidget {
  final User currentUser;
  final bool isCityChat;
  const ChatScreen({Key key, this.currentUser, this.isCityChat}): super(key: key);
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  String getMessageBucket(){
   return (widget.isCityChat) ? 'chennai-city' : widget.currentUser.userWard;
 }
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('chat-messages')
          .document(getMessageBucket())
          .collection('messages')
          .orderBy('sentAt')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return ChatMessage(text:record.message,
      sentBy: record.sentBy,
      loggedInUser: widget.currentUser.userName,
      sentAt: new DateTime.fromMicrosecondsSinceEpoch(record.sentTime.microsecondsSinceEpoch));
  }


  @override
  Widget build(BuildContext context) {
    String chatTitle  = (widget.isCityChat) ? "Chennai Chat Room" : "Ward Chat Room";

    return new Scaffold(
        appBar: new AppBar(title: new Text(chatTitle)),

        body: new Container(
              child : new Column(
                children: <Widget>[
                  new Flexible(
                      child: _buildBody(context)
                  ),
                  new Divider(
                    height: 1.0,
                  ),
                  new Container(decoration: new BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                    child: ChatEnvironment(widget.currentUser,widget.isCityChat),)
                ],
              ),
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
