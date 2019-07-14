import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/utils/globals.dart';
import 'package:namma_chennai/utils/TopicManager.dart';
import 'chat.dart';
import 'package:namma_chennai/utils/constants.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';
final SharedPrefs _sharedPrefs = new SharedPrefs();

class ChatSelection extends StatefulWidget {
  @override
  _ChatSelectionState createState() => _ChatSelectionState();
}

class _ChatSelectionState extends State<ChatSelection> {
  User currentUser;
  String userId;
  String userZone;
  bool _isLoading = true;
  bool _hasUserFilledDetails = false;
  bool isSubscribedToCityChat = false;
  bool isSubscribedToZoneChat = false;

  TopicManager topicManager = TopicManager();
  void initState() {
    super.initState();
    _sharedPrefs.getApplicationSavedInformation(Constants.IS_SUBSCRIBED_TO_CITY_CHAT).then((val){
      isSubscribedToCityChat = (val == Constants.SUBSCRIBED);
    });

    _sharedPrefs.getApplicationSavedInformation(Constants.IS_SUBSCRIBED_TO_ZONE_CHAT).then((val){
      isSubscribedToZoneChat = (val == Constants.SUBSCRIBED);
    });

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
        //should be removed when user ward details are added.
        setState(() {
          _isLoading = false;
          _hasUserFilledDetails = (currentUser.userZone != null && currentUser.userName != null && currentUser.userZone != '' && currentUser.userName != '');
        });
      });
    });
  }

  void chatNotificationToggled(bool isCityChat) {
    if(isCityChat){
      isSubscribedToCityChat = !isSubscribedToCityChat;
    } else {
      isSubscribedToZoneChat = !isSubscribedToZoneChat;
    }
  }
  Widget _loadingView() {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget getButtonForChat(bool isCityChat) {
    userZone = topicManager.getUSerZone(currentUser.userZone);
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
                        currentUser: currentUser,
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
      body: (_isLoading) ? _loadingView() : displayScreen(),
    );
  }
}
