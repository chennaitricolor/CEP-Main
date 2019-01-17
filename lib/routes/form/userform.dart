import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/user.dart';

Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('users');

class UserForm extends StatefulWidget {
  String phonenumber;

  UserForm({this.phonenumber});

  @override
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  DocumentSnapshot user;
  User updatedUser;

  getUser() {
    collectionRef
        .where("phonenumber", isEqualTo: "+91" + widget.phonenumber)
        .snapshots()
        .listen((data) =>
            data.documents.forEach((doc) => user = doc));
  }

  saveOrUpdateUser() {
    if(user != null){
      collectionRef
          .document(user.documentID)
          .updateData(updatedUser.toJson())
          .catchError((e) {
        print(e);
      });
    } else {
      updatedUser.id = (DateTime.now().toUtc().millisecondsSinceEpoch).toString();
      collectionRef
          .document()
          .setData(updatedUser.toJson())
          .catchError((e) {
        print(e);
      });
    }
    Navigator.pushNamed(context, "/home");
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            stops: [0.5, 0.5],
            tileMode: TileMode.clamp,
            colors: [
              Colors.redAccent,
              Color(0xFFEEEEEE),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40.0),
            ),
            Text(
              'Profile Information',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30.0,
                  color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: new Container(
                color: Colors.transparent,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300.0,
                  child: TextField(
                      keyboardType: TextInputType.text,
                      maxLength: 30,
                      textInputAction: TextInputAction.next,
                      onChanged: (String name) {
                          if(updatedUser == null){
                            updatedUser = new User("+91" + widget.phonenumber);
                          }
                          updatedUser.name = name;
                      },
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      ),
                      autofocus: true),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: new Container(
                color: Colors.transparent,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300.0,
                  child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 50,
                      textInputAction: TextInputAction.next,
                      onChanged: (String email) {
                          if(updatedUser == null){
                            updatedUser = new User("+91" + widget.phonenumber);
                          }
                          updatedUser.email = email;
                      },
                      decoration: InputDecoration(
                        labelText: "Email (optional)",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      ),
                      autofocus: true),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () {
                saveOrUpdateUser();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 58.0),
                child: Text(
                  'Proceed',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
