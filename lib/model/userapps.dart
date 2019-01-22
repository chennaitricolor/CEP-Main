import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/apps.dart';

class UserApps {

  String appId;
  String userId;
  List<Apps> apps;
  List<Apps> layout;

  UserApps(this.appId);

  UserApps.fromSnapShot(DocumentSnapshot snapshot){
    this.appId = snapshot['app_id'];
    this.userId = snapshot['user_id'];
    this.apps = snapshot['apps'];
    this.layout = snapshot['layout'];
  }

  UserApps.fromJson(Map<String, dynamic> json){
    this.appId = json['app_id'];
    this.userId = json['user_id'];
    this.apps = json['apps'];
    this.layout = json['layout'];
  }

  Map<String, dynamic> toJson() =>
  {
    'app_id': this.appId,
    'user_id': this.userId,
    'apps': this.apps,
    'layout': this.layout
  };
}

