import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  String id;
  String name;
  String phonenumber;
  String email;
  String ward;
  String zone;

  User(this.phonenumber);

  User.fromSnapShot(DocumentSnapshot snapshot){
    this.id = snapshot['id'];
    this.phonenumber = snapshot['phonenumber'];
    this.name = snapshot['name'];
    this.email = snapshot['email'];
    this.ward = snapshot['ward'];
    this.zone = snapshot['zone'];
  }

  User.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.phonenumber = json['phonenumber'];
    this.name = json['name'];
    this.email = json['email'];
    this.ward = json['ward'];
    this.zone = json['zone'];
  }

  Map<String, dynamic> toJson() =>
  {
    'id': this.id,
    'phonenumber': this.phonenumber,
    'name': this.name,
    'email': this.email,
    'ward': this.ward,
    'zone': this.zone,
  };
}

