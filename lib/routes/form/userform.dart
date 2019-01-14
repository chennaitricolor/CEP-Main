import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Access a Cloud Firestore instance from your Activity
Firestore db = Firestore.instance;

// Reference to a Collection
CollectionReference collectionRef = db.collection('users');

class UserForm extends StatefulWidget {
  String phonenumber;

  UserForm({this.phonenumber});

  @override
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  @override
  Widget build(BuildContext context) {
    getUser() {
      collectionRef
          .where("phonenumber", isEqualTo: "+91" + widget.phonenumber)
          .snapshots()
          .listen((data) =>
              data.documents.forEach((doc) => print(doc["phonenumber"])));
    }

    return FlatButton(
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        getUser();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 98.0),
        child: Text(
          'Test Search',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
