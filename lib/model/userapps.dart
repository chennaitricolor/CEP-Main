import 'package:cloud_firestore/cloud_firestore.dart';

class UserApps {
  String userId;
  List<String> apps;
  List<String> layout;

  UserApps(this.userId);

  UserApps.fromSnapShot(DocumentSnapshot snapshot) {
    this.userId = snapshot['user_id'];
    this.apps = buildAppsList(snapshot['apps']);
    this.layout = buildAppsList(snapshot['layout']);
  }

  UserApps.fromJson(Map<String, dynamic> json) {
    this.userId = json['user_id'];
    this.apps = buildAppsList(json['apps']);
    this.layout = buildAppsList(json['layout']);
  }

  Map<String, dynamic> toJson() => {
    'user_id': this.userId,
    'apps': this.apps,
    'layout': this.layout
  };

  buildAppsList(List<dynamic> appsIdList) {
    List<String> appsList = new List();
    for (String appId in appsIdList) {
      appsList.add(appId);
    }
    return appsList;
  }
}
