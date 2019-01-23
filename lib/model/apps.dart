import 'package:cloud_firestore/cloud_firestore.dart';

enum Category {
  GOVT,
  NGO,
  PEER_TO_PEER,
  COMMERCIAL
}

class Apps {

  String appId;
  String appName;
  String appDesc;
  List<String> appMetaTags;
  String appIconUrl;
  String appUrl;
  String appFeatureScore;
  String appFeaturePref;
  DateTime appLaunchDate;
  String appCategory;

  Apps.fromSnapShot(DocumentSnapshot snapshot){
    this.appId = snapshot['app_id'];
    this.appName = snapshot['app_name'];
    this.appDesc = snapshot['app_desc'];
    // this.appMetaTags = snapshot['app_meta_tags'];
    this.appIconUrl = snapshot['app_icon_url'];
    this.appUrl = snapshot['app_url'];
    this.appFeatureScore = snapshot['app_feature_score'];
    this.appFeaturePref = snapshot['app_feature_pref'];
    this.appLaunchDate = snapshot['app_launch_date'];
    this.appCategory = snapshot['app_category'];
  }

  Apps.fromJson(Map<String, dynamic> json){
    this.appId = json['app_id'];
    this.appName = json['app_name'];
    this.appDesc = json['app_desc'];
    // this.appMetaTags = json['app_meta_tags'];
    this.appIconUrl = json['app_icon_url'];
    this.appUrl = json['app_url'];
    this.appFeatureScore = json['app_feature_score'];
    this.appFeaturePref = json['app_feature_pref'];
    this.appLaunchDate = json['app_launch_date'];
    this.appCategory = json['app_category'];
  }

  Map<String, dynamic> toJson() =>
  {
    'app_id': this.appId,
    'app_name': this.appName,
    'app_desc': this.appDesc,
    // 'app_meta_tags': this.appMetaTags,
    'app_icon_url': this.appIconUrl,
    'app_url': this.appUrl,
    'app_feature_score': this.appFeatureScore,
    'app_feature_pref': this.appFeaturePref,
    'app_launch_date': this.appLaunchDate,
    'app_category': this.appCategory
  };
}

