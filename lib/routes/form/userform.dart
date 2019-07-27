import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_chennai/locale/all_translations.dart';
import 'package:hello_chennai/model/user.dart';
import 'package:intl/intl.dart';
import 'package:hello_chennai/utils/api.dart';
import 'package:hello_chennai/utils/shared_prefs.dart';
import 'package:hello_chennai/utils/TopicManager.dart';
import 'package:location/location.dart';

SharedPrefs _sharedPrefs = new SharedPrefs();
Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('users');
API api = new API();


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
  Gender selectedGender;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController aadharController = new TextEditingController();
  TextEditingController panController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();

  int _radioValueForGender = -1;

  void _handleRadioValueChangeForGender(int value) {
    setState(() {
      _radioValueForGender = value;
      switch (_radioValueForGender) {
        case 0:
          currentUser.userGender = "MALE";
          break;
        case 1:
          currentUser.userGender = "FEMALE";
          break;
        case 2:
          currentUser.userGender = "OTHER";
          break;
      }
    });
  }

  setRadioValueForGender(type) {
    switch (type) {
      case "MALE":
        _handleRadioValueChangeForGender(0);
        break;
      case "FEMALE":
        _handleRadioValueChangeForGender(1);
        break;
      case "OTHER":
        _handleRadioValueChangeForGender(2);
        break;
      default:
        _handleRadioValueChangeForGender(0);
    }
  }

  getUser() {
    _sharedPrefs.getApplicationSavedInformation('loggedinuser').then((userId) {
      collectionRef
          .where("user_id", isEqualTo: userId)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        List<DocumentSnapshot> docs = snapshot.documents;
        for (DocumentSnapshot doc in docs) {
          documentId = doc.documentID;
          currentUser = new User.fromSnapShot(doc);
        }
        setState(() {
          usernameController.text = currentUser.userName;
          emailController.text = currentUser.userEmail;
          aadharController.text = currentUser.userAadharId;
          panController.text = currentUser.userPanId;
          locationController.text = "${currentUser.userWard} - ${currentUser.userZone} (${currentUser.userGeo})";
          var formatter = new DateFormat('yyyy-MM-dd');
          dobController.text = currentUser.userDob == null
              ? ""
              : formatter.format(currentUser.userDob.toDate());
          setRadioValueForGender(currentUser.userGender);
        });
      });
    });
  }

  saveOrUpdateUser() {
    TopicManager topicManager = new TopicManager();
    topicManager.unSubscribeToZoneChatNotification(currentUser.oldUserZone);
    topicManager.subscribeToZoneChatNotification(currentUser.userZone);
    collectionRef
        .document(documentId)
        .updateData(currentUser.toJson())
        .catchError((e) {
      print(e);
    });
    Navigator.of(context).pop();
  }

  genderChange(Gender gender) {
    if (currentUser != null) {
      currentUser.userGender = gender.toString();
    } else {
      currentUser = new User(
          "+91" + widget.phonenumber, widget.userid, Persona.USER.toString());
      currentUser.userGender = gender.toString();
    }
  }

  Future<Null> dateSelector(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(Duration(days: 365 * 25)),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        currentUser.userDob = Timestamp.fromDate(picked);
        var formatter = new DateFormat('yyyy-MM-dd');
        dobController.text = formatter.format(picked);
      });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  EdgeInsets defaultSpacing = EdgeInsets.only(bottom: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: false,
          title: Text('Personal Information'),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                child: TextField(
                    keyboardType: TextInputType.text,
                    maxLength: 30,
                    controller: usernameController,
                    textInputAction: TextInputAction.next,
                    onChanged: (String name) {
                      currentUser.userName = name;
                    },
                    decoration: InputDecoration(
                      labelText: allTranslations.text('translation_30'),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    ),
                    autofocus: false),
              ),
              Container(
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    onChanged: (String email) {
                      currentUser.userEmail = email;
                    },
                    decoration: InputDecoration(
                      labelText: allTranslations.text('translation_31'),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    )),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(width: 1, color: Colors.black54)),
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(5),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      groupValue: _radioValueForGender,
                      onChanged: _handleRadioValueChangeForGender,
                    ),
                    InkWell(
                      onTap: () {
                        _handleRadioValueChangeForGender(0);
                      },
                      child: new Text(
                        allTranslations.text('translation_32'),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    new Radio(
                      value: 1,
                      groupValue: _radioValueForGender,
                      onChanged: _handleRadioValueChangeForGender,
                    ),
                    InkWell(
                      onTap: () {
                        _handleRadioValueChangeForGender(1);
                      },
                      child: new Text(
                        allTranslations.text('translation_33'),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                    new Radio(
                      value: 2,
                      groupValue: _radioValueForGender,
                      onChanged: _handleRadioValueChangeForGender,
                    ),
                    InkWell(
                      onTap: () {
                        _handleRadioValueChangeForGender(2);
                      },
                      child: new Text(
                        allTranslations.text('translation_34'),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: defaultSpacing,
                child: GestureDetector(
                    onTap: () => dateSelector(context),
                    child: AbsorbPointer(
                      child: TextField(
                          controller: dobController,
                          decoration: InputDecoration(
                            labelText: allTranslations.text('translation_35'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)),
                          )),
                    )),
              ),
              Container(
                padding: defaultSpacing,
                child: TextField(
                    controller: locationController,
                    keyboardType: TextInputType.multiline,
                    maxLength: null,
                    textInputAction: TextInputAction.next,
                    onTap: () {
                      var location = new Location();
                      try {
                        location.getLocation().then((val) {
                          locationController.text = "Identifying...";
                          currentUser.userGeo = val.latitude.toString() +
                              ", " +
                              val.longitude.toString();
                          print(currentUser.userGeo);
                          api
                              .getZone(val.latitude.toString(),
                                  val.longitude.toString())
                              .then((response) {
                            var json = convert.jsonDecode(response.body);
                            setState(() {
                              currentUser.oldUserZone = currentUser.userZone;
                              if (json['data'] != null &&
                                  json['data']['wardNo'] != null) {
                                currentUser.userWard = "${json['data']['wardNo']}";
                                currentUser.userZone = "${json['data']['zoneInfo']}";

                              } else {
                                currentUser.userWard = "0";
                                currentUser.userZone = "Zone 0 Other"; //Do not change the format - using regular expression matching - Surya
                              }
                              locationController.text =
                                  "${currentUser.userWard} - ${currentUser.userZone} (${currentUser.userGeo})";
                            });
                          });
                        });
                      } catch (e) {
                        if (e.code == 'PERMISSION_DENIED') {
                          print("Permission Denied");
                        }
                      }
                    },
                    decoration: InputDecoration(
                      labelText: allTranslations.text('translation_36'),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    )),
              ),
              Container(
                child: TextField(
                    keyboardType: TextInputType.number,
                    controller: aadharController,
                    maxLength: 50,
                    textInputAction: TextInputAction.next,
                    onChanged: (String email) {
                      currentUser.userAadharId = email;
                    },
                    decoration: InputDecoration(
                      labelText: allTranslations.text('translation_37'),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    )),
              ),
              Container(
                child: TextField(
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    controller: panController,
                    textInputAction: TextInputAction.next,
                    onChanged: (String email) {
                      currentUser.userPanId = email;
                    },
                    decoration: InputDecoration(
                      labelText: allTranslations.text('translation_38'),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    )),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        onPressed: () {
                          saveOrUpdateUser();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 12.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                allTranslations.text('translation_39'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                allTranslations.text('translation_29'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ))),
            ],
          ),
        )));
  }
}
