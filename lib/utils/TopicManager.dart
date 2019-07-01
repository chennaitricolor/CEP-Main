import 'package:firebase_messaging/firebase_messaging.dart';

class TopicManager{
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  void subscribeToCityChatNotification(){
    firebaseMessaging.subscribeToTopic("chat-chennai");
  }
  void unSubscribeToCityChatNotification(){
    firebaseMessaging.unsubscribeFromTopic("chat-chennai");
  }
  void subscribeToZoneChatNotification(String userZone){
    firebaseMessaging.subscribeToTopic(userZone);
  }
  void unSubscribeToZoneChatNotification(String userZone){
    firebaseMessaging.unsubscribeFromTopic(userZone);
  }
  String getUSerZone(String zoneRawString){
    String match;
    RegExp exp = new RegExp(r"(Zone \d* (\w*))");
    Iterable<Match> matches = exp.allMatches(zoneRawString);
    for (Match m in matches) {
      match = m.group(2);
    }
    return match;
  }
}