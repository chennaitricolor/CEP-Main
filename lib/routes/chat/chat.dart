import 'package:flutter/material.dart';
import 'chatmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatenvironement.dart';
import 'Record.dart';
import 'package:hello_chennai/model/user.dart';
import 'package:hello_chennai/utils/constants.dart';
import 'package:hello_chennai/utils/TopicManager.dart';

class Chat extends StatefulWidget {
  final User currentUser;
  final bool isCityChat;
  final String userZone;
  final bool isSubscribedToNotifications;
  final Function(bool isCityChat) chatNotificationToggled;
  const Chat({Key key, this.currentUser, this.isCityChat, this.userZone, this.isSubscribedToNotifications, this.chatNotificationToggled}): super(key: key);
  @override
  State createState() => new ChatState();
}

class ChatState extends State<Chat> {
  ScrollController _listVIewController = ScrollController();
  TopicManager topicManager = new TopicManager();
  bool isSubscribedToNotifications;
  void initState(){
    isSubscribedToNotifications= widget.isSubscribedToNotifications;
  }
  String getMessageBucket(){
  return (widget.isCityChat) ? Constants.CHENNAI_CITY_TOPIC : widget.userZone;
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
      sentId: record.sentId,
      loggedInUser: widget.currentUser.userId,
      sentAt: new DateTime.fromMicrosecondsSinceEpoch(record.sentTime.microsecondsSinceEpoch));
  }

  void subscribeToChat(){
    if(widget.isCityChat){
      topicManager.subscribeToCityChatNotification();
      setState((){
        isSubscribedToNotifications = true;
      });
    } else {
      topicManager.subscribeToZoneChatNotification(widget.userZone);
      setState((){
        isSubscribedToNotifications = true;
      });
    }
  }

  void unSubscribeToChat(){
    if(widget.isCityChat){
      topicManager.unSubscribeToCityChatNotification();
      setState((){
        isSubscribedToNotifications = false;
      });
    } else {
      topicManager.unSubscribeToZoneChatNotification(widget.userZone);
      setState((){
        isSubscribedToNotifications = false;
      });
    }
  }

  void notificationIconButtonClicked(){
    widget.chatNotificationToggled(widget.isCityChat);
    if(isSubscribedToNotifications){
     return unSubscribeToChat();
    }
    subscribeToChat();
  }


  IconData getIconType(){
    return isSubscribedToNotifications ? Icons.volume_up : Icons.volume_off;
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) =>{
     _listVIewController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut)
  });
    String chatTitle  = (widget.isCityChat) ? "Chennai City Room" : widget.userZone;

    return new Scaffold(
        appBar: new AppBar(
            title: new Text(chatTitle),
            actions: <Widget>[
                  IconButton(
                  icon: Icon(getIconType()),
                onPressed: () {
                  notificationIconButtonClicked();
                },
              )
            ],
        ),

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
//             decoration: new BoxDecoration(
//              image: new DecorationImage(
//                image: new AssetImage("assets/images/apps/telegram01.jpg"),
//                fit: BoxFit.fill,
//              ),
//            ),
        )
    );
  }
}
