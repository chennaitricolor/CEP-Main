import 'package:flutter/material.dart';
import 'package:hello_chennai/model/user.dart';
import 'package:hello_chennai/utils/TopicManager.dart';
import 'chat.dart';
import 'package:hello_chennai/utils/Strings.dart';
import 'package:hello_chennai/utils/shared_prefs.dart';
final SharedPrefs _sharedPrefs = new SharedPrefs();

class ChatSelection extends StatefulWidget {
  final User currentUser;
  const ChatSelection({Key key, this.currentUser}) : super(key: key);

  @override
  _ChatSelectionState createState() => _ChatSelectionState();
}

class _ChatSelectionState extends State<ChatSelection> {
  String userId;
  String userZone;
  bool _hasUserFilledDetails = true;
  bool isSubscribedToCityChat = false;
  bool isSubscribedToZoneChat = false;

  TopicManager topicManager = TopicManager();
  void initState() {
    super.initState();
    _sharedPrefs.getApplicationSavedInformation(Strings.IS_SUBSCRIBED_TO_CITY_CHAT).then((val){
      isSubscribedToCityChat = (val == Strings.SUBSCRIBED);
    });

    _sharedPrefs.getApplicationSavedInformation(Strings.IS_SUBSCRIBED_TO_ZONE_CHAT).then((val){
      isSubscribedToZoneChat = (val == Strings.SUBSCRIBED);
    });
    _hasUserFilledDetails = (widget.currentUser.userZone != null && widget.currentUser.userName != null && widget.currentUser.userZone != '' && widget.currentUser.userName != '');
  }

  void chatNotificationToggled(bool isCityChat) {
    if(isCityChat){
      isSubscribedToCityChat = !isSubscribedToCityChat;
    } else {
      isSubscribedToZoneChat = !isSubscribedToZoneChat;
    }
  }

  Widget getButtonForChat(bool isCityChat) {
    userZone = topicManager.getUSerZone(widget.currentUser.userZone);
    String chatTitle = (isCityChat) ? "Chennai Chat Room" : userZone+" Zone Room";
    bool isNotificationSubscribed = (isCityChat) ? isSubscribedToCityChat : isSubscribedToZoneChat;

    return new Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: const EdgeInsets.only(bottom: 15),
      child: new FlatButton(
          color: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Chat(isCityChat: isCityChat,
                        currentUser: widget.currentUser,
                        userZone : userZone,
                        isSubscribedToNotifications: isNotificationSubscribed,
                        chatNotificationToggled: chatNotificationToggled,
                      )
              ),
            );
          },
          child: new Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: new Text(chatTitle,
                style: TextStyle(color: Colors.white, fontSize: 15)),
          )),
    );
  }

  Widget displayScreen() {
    if(!_hasUserFilledDetails){
      return Container(
        padding: const EdgeInsets.fromLTRB(20,50,10,5 ),
        child: new Text("Please add name and location details in profile section to continue using Chat")
      );
    }
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.chat,
          color: Colors.grey,
          size: 180.0,
        ),
        SizedBox(
          height: 20,
        ),
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
      body: displayScreen(),
    );
  }
}
