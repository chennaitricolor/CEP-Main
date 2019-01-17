import 'package:cloud_firestore/cloud_firestore.dart';

class Apps {

  String appId;
  String devEmail;
  String devName;
  String devPhone;
  String iconUrl;
  String isVisible;
  String link;
  String name;

  Apps.fromSnapShot(DocumentSnapshot snapshot){
    this.appId = snapshot['app_id'];
    this.devEmail = snapshot['dev_email'];
    this.devName = snapshot['dev_name'];
    this.devPhone = snapshot['dev_phone'];
    this.iconUrl = snapshot['icon_url'];
    this.isVisible = snapshot['is_visible'];
    this.link = snapshot['link'];
    this.name = snapshot['name'];
  }

  Apps.fromJson(Map<String, dynamic> json){
    this.appId = json['app_id'];
    this.devEmail = json['dev_email'];
    this.devName = json['dev_name'];
    this.devPhone = json['dev_phone'];
    this.iconUrl = json['icon_url'];
    this.isVisible = json['is_visible'];
    this.link = json['link'];
    this.name = json['name'];
  }

  Map<String, dynamic> toJson() =>
  {
    'app_id': this.appId,
    'dev_email': this.devEmail,
    'dev_name': this.devName,
    'dev_phone': this.devPhone,
    'icon_url': this.iconUrl,
    'is_visible': this.isVisible,
    'link': this.link,
    'name': this.name,
  };
}

