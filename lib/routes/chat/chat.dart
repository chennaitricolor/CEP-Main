import 'package:flutter/material.dart';
import 'chatmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatenvironement.dart';
import 'Record.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/utils/constants.dart';

class Chat extends StatefulWidget {
  final User currentUser;
  final bool isCityChat;
  final String userZone;
  const Chat({Key key, this.currentUser, this.isCityChat, this.userZone}): super(key: key);
  @override
  State createState() => new ChatState();
}

class ChatState extends State<Chat> {
  ScrollController _listVIewController = ScrollController();
  String getMessageBucket(){

   return (widget.isCityChat) ? StringConstants.CHENNAI_CITY_TOPIC : widget.userZone;
 }
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('chat-messages')
          .document(getMessageBucket())
          .collection('messages')
          .orderBy('sentAt',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      reverse:true,
      shrinkWrap: true,
      controller: _listVIewController,
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
    WidgetsBinding.instance.addPostFrameCallback((_) =>{
     _listVIewController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut)
  });
    String chatTitle  = (widget.isCityChat) ? "Chennai City Room" : widget.userZone;

    return new Scaffold(
        appBar: new AppBar(title: new Text(chatTitle)),

        body: new Container(
              child : new Column(
                mainAxisAlignment: MainAxisAlignment.end,

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
                    child: ChatEnvironment(widget.currentUser,widget.isCityChat, widget.userZone),
                  )
                ],
              ),
             decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/apps/telegram01.jpg"),
                fit: BoxFit.fill,
              ),
            ),
        )
    );
  }
}
