import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hello_chennai/utils/Strings.dart';
import 'package:hello_chennai/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

final SharedPrefs _sharedPrefs = new SharedPrefs();

class TopicManager{
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  Future<bool> isSubscribedToCityChatNotifications() async{
    String value =  await _sharedPrefs.getApplicationSavedInformation(Strings.IS_SUBSCRIBED_TO_CITY_CHAT);
    return (value == Strings.SUBSCRIBED);
  }

  Future<bool>isSubscribedToZoneChatNotifications() async{
    String value = await _sharedPrefs.getApplicationSavedInformation(Strings.IS_SUBSCRIBED_TO_ZONE_CHAT);
    debugPrint("##@@@@### Zone");

    return (value == Strings.SUBSCRIBED);
  }
  void subscribeToCityChatNotification(){
    _sharedPrefs.setApplicationSavedInformation(Strings.IS_SUBSCRIBED_TO_CITY_CHAT, Strings.SUBSCRIBED);
    firebaseMessaging.subscribeToTopic(Strings.CHENNAI_CITY_TOPIC);
  }
  void unSubscribeToCityChatNotification(){
    _sharedPrefs.setApplicationSavedInformation(Strings.IS_SUBSCRIBED_TO_CITY_CHAT, Strings.UNSUBSCRIBED);
    firebaseMessaging.unsubscribeFromTopic(Strings.CHENNAI_CITY_TOPIC);
  }
  void subscribeToZoneChatNotification(String userZone){
    _sharedPrefs.setApplicationSavedInformation(Strings.IS_SUBSCRIBED_TO_ZONE_CHAT, Strings.SUBSCRIBED);
    firebaseMessaging.subscribeToTopic(userZone);
  }
  void unSubscribeToZoneChatNotification(String userZone){
    if(userZone != null){
      _sharedPrefs.setApplicationSavedInformation(Strings.IS_SUBSCRIBED_TO_ZONE_CHAT, Strings.UNSUBSCRIBED);
      firebaseMessaging.unsubscribeFromTopic(userZone);
    }
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
