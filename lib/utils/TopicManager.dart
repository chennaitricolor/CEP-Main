import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:namma_chennai/utils/constants.dart';
import 'package:flutter/material.dart';
class TopicManager{
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  void subscribeToCityChatNotification(){
    firebaseMessaging.subscribeToTopic(StringConstants.CHENNAI_CITY_TOPIC);
  }
  void unSubscribeToCityChatNotification(){

    firebaseMessaging.unsubscribeFromTopic(StringConstants.CHENNAI_CITY_TOPIC);
  }
  void subscribeToZoneChatNotification(String userZone){
    firebaseMessaging.subscribeToTopic(getUSerZone(userZone));
  }
  void unSubscribeToZoneChatNotification(String userZone){
    if(userZone != null)
      firebaseMessaging.unsubscribeFromTopic(getUSerZone(userZone));
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
