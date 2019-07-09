import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:namma_chennai/utils/constants.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

final SharedPrefs _sharedPrefs = new SharedPrefs();

class TopicManager{
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  Future<bool> isSubscribedToCityChatNotifications() async{
    String value =  await _sharedPrefs.getApplicationSavedInformation(Constants.IS_SUBSCRIBED_TO_CITY_CHAT);
    return (value == Constants.SUBSCRIBED);
  }

  Future<bool>isSubscribedToZoneChatNotifications() async{
    String value = await _sharedPrefs.getApplicationSavedInformation(Constants.IS_SUBSCRIBED_TO_ZONE_CHAT);
    debugPrint("##@@@@### Zone");

    return (value == Constants.SUBSCRIBED);
  }
  void subscribeToCityChatNotification(){
    _sharedPrefs.setApplicationSavedInformation(Constants.IS_SUBSCRIBED_TO_CITY_CHAT, Constants.SUBSCRIBED);
    firebaseMessaging.subscribeToTopic(Constants.CHENNAI_CITY_TOPIC);
  }
  void unSubscribeToCityChatNotification(){
    _sharedPrefs.setApplicationSavedInformation(Constants.IS_SUBSCRIBED_TO_CITY_CHAT, Constants.UNSUBSCRIBED);
    firebaseMessaging.unsubscribeFromTopic(Constants.CHENNAI_CITY_TOPIC);
  }
  void subscribeToZoneChatNotification(String userZone){
    _sharedPrefs.setApplicationSavedInformation(Constants.IS_SUBSCRIBED_TO_ZONE_CHAT, Constants.SUBSCRIBED);
    firebaseMessaging.subscribeToTopic(getUSerZone(userZone));
  }
  void unSubscribeToZoneChatNotification(String userZone){
    if(userZone != null){
      _sharedPrefs.setApplicationSavedInformation(Constants.IS_SUBSCRIBED_TO_ZONE_CHAT, Constants.UNSUBSCRIBED);
      firebaseMessaging.unsubscribeFromTopic(getUSerZone(userZone));
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
