import 'package:cloud_firestore/cloud_firestore.dart';

class MyApps {

  String appId;
  bool isInstalled;
  String userId;

  MyApps(this.appId);

  MyApps.fromSnapShot(DocumentSnapshot snapshot){
    this.appId = snapshot['app_id'];
    this.isInstalled = snapshot['is_installed'];
    this.userId = snapshot['user_id'];
  }

  MyApps.fromJson(Map<String, dynamic> json){
    this.appId = json['app_id'];
    this.isInstalled = json['is_installed'];
    this.userId = json['user_id'];
  }

  Map<String, dynamic> toJson() =>
  {
    'app_id': this.appId,
    'is_installed': this.isInstalled,
    'user_id': this.userId
  };
}

