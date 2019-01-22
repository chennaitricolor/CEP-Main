import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';

SharedPrefs _sharedPrefs = new SharedPrefs();
Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('users');

class UserForm extends StatefulWidget {
  final String phonenumber;
  final String userid;

  UserForm({this.phonenumber, this.userid});

  @override
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  User currentUser;
  String documentId;

  getUser() {
    collectionRef
        .where("user_id", isEqualTo: widget.userid)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
          List<DocumentSnapshot> docs = snapshot.documents;
          for (DocumentSnapshot doc in docs) {
            documentId = doc.documentID;
            User user = new User.fromSnapShot(doc);
            currentUser = user;
          }
        });
  }

  saveOrUpdateUser() {
    if (documentId != null) {
      collectionRef
          .document(documentId)
          .updateData(currentUser.toJson())
          .catchError((e) {
        print(e);
      });
    } else {
      currentUser.userId = widget.userid;
      collectionRef.document().setData(currentUser.toJson()).catchError((e) {
        print(e);
      });
    }
    _sharedPrefs.setApplicationSavedInformation('loggedinuser', currentUser.userId);
    Navigator.pushNamed(context, "/home");
  }

  genderChange(Gender gender){
    if(currentUser != null){
      currentUser.userGender = gender.toString();
    } else {
      currentUser = new User("+91" + widget.phonenumber, widget.userid, Persona.USER.toString());
      currentUser.userGender = gender.toString();
    }
  }

  Future<Null> dateSelector(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now());
        if (picked != null)
        setState(() {
          currentUser.userDob = picked;
        });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.center,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.5, 0.5],
            tileMode: TileMode.clamp,
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.redAccent,
              Color(0xFFEEEEEE),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 80),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Profile Information',
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
                    Text(
                      '(More about you)',
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Container(
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
                        if (currentUser == null) {
                          currentUser = new User("+91" + widget.phonenumber, widget.userid, Persona.USER.toString());
                        }
                        currentUser.userName = name;
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
              child: Container(
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
                        if (currentUser == null) {
                          currentUser = new User("+91" + widget.phonenumber, widget.userid, Persona.USER.toString());
                        }
                        currentUser.userEmail = email;
                      },
                      decoration: InputDecoration(
                        labelText: "Email (optional)",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      )
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            DropdownButton<Gender>(
              hint: Text("Select Gender"),
              items: <Gender>[Gender.MALE, Gender.FEMALE, Gender.TRANSGENDER].map((Gender value) {
                return DropdownMenuItem<Gender>(
                  value: value,
                  child: Text(value.toString().substring(7)),
                );
              }).toList(),
              onChanged: (Gender value) {
                if (currentUser == null) {
                  currentUser = new User("+91" + widget.phonenumber, widget.userid, Persona.USER.toString());
                }
                currentUser.userGender = value.toString();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Container(
                  width: 300.0,
                  child: GestureDetector(
                          onTap:() => dateSelector(context),
                          child:AbsorbPointer(
                            child: TextField(
                                decoration: InputDecoration(
                                  labelText: "Date of Birth",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.teal)),
                                )
                            ),
                          )
                        ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
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
                  'Update',
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
