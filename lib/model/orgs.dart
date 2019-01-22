import 'package:cloud_firestore/cloud_firestore.dart';

class Orgs {

  String orgId;
  String userId;
  String orgName;
  String orgType;
  String orgDocUrl;

  Orgs.fromSnapShot(DocumentSnapshot snapshot){
    this.orgId = snapshot['org_id'];
    this.userId = snapshot['user_id'];
    this.orgName = snapshot['org_name'];
    this.orgType = snapshot['org_type'];
    this.orgDocUrl = snapshot['org_doc_url'];
  }

  Orgs.fromJson(Map<String, dynamic> json){
    this.orgId = json['org_id'];
    this.userId = json['user_id'];
    this.orgName = json['org_name'];
    this.orgType = json['org_type'];
    this.orgDocUrl = json['org_doc_url'];
  }

  Map<String, dynamic> toJson() =>
  {
    'org_id': this.orgId,
    'user_id': this.userId,
    'org_name': this.orgName,
    'org_type': this.orgType,
    'org_doc_url': this.orgDocUrl,
  };
}

