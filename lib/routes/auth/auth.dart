import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hello_chennai/locale/all_translations.dart';
import 'package:hello_chennai/model/user.dart';
import 'package:hello_chennai/routes/language/language.dart';
import 'package:hello_chennai/utils/default_data.dart';
import 'package:hello_chennai/routes/form/userform.dart';
import 'package:hello_chennai/utils/shared_prefs.dart';
import 'package:flutter/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final SharedPrefs _sharedPrefs = new SharedPrefs();
CollectionReference collectionRef1 = db.collection('users');

class Auth extends StatefulWidget {
  @override
  AuthState createState() => AuthState();
}

enum AuthStage { INIT, SMS_SENT, SMS_TIMEOUT, PHONE_VERIFIED, PHONE_FAILED }

class AuthState extends State<Auth> {
  String verificationId;
  String smsCode;
  String phonenumber;
  AuthStage status = AuthStage.INIT;
  String prefLang = "Language";
  bool isLoading = false;
  FirebaseUser currentUser;

  var otpController = new TextEditingController();

  Future<void> verifyPhoneNumber() async {
    // isLoading = true;
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      print(verId);
      this.verificationId = verId;
      setState(() {
        status = AuthStage.SMS_TIMEOUT;
      });
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      print(verId);
      this.verificationId = verId;
      setState(() {
        status = AuthStage.SMS_SENT;
      });
    };

    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      // _showDialog("Verfication Completed");
      currentUser = user;
      setState(() {
        status = AuthStage.PHONE_VERIFIED;
      });
      goHome(user);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print("Exception");
      _showDialog(exception.message + " " + exception.code);
      setState(() {
        status = AuthStage.PHONE_FAILED;
      });
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: "+91" + this.phonenumber,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed);
  }

  goHome(user) {
    makeEntry(user.uid);
    _sharedPrefs.setApplicationSavedInformation('loggedinuser', user.uid);
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  signIn()  {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: this.verificationId, smsCode: this.smsCode
    );
    _auth.signInWithCredential(credential)
        .then((user) {
      // _showDialog(user.toString());
      goHome(user);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             UserForm(phonenumber: phonenumber, userid: user.uid)));
    }).catchError((e) {
      _showDialog(e.toString());
      print("Signin exception");
      print(e);
    });
  }

  void _showDialog(content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert"),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _sharedPrefs.getApplicationSavedInformation("language").then((val) {
      setState(() {
        prefLang = val;
      });
    });
  }

  makeEntry(userId) {
    _sharedPrefs.getApplicationSavedInformation("messageToken").then((token) {
      
      collectionRef1
          .where("user_phone_number", isEqualTo: phonenumber)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        String docId = "";
        User user;
        List<DocumentSnapshot> docs = snapshot.documents;
        for (DocumentSnapshot doc in docs) {
          user = User.fromSnapShot(doc);
          docId = doc.documentID;
        }
        if (docId.length > 0) {
          user.userId = userId;
          user.messageToken = token;
          collectionRef1
              .document(docId)
              .updateData(user.toJson())
              .catchError((e) {
            print(e);
          });
        } else {
          user = new User(phonenumber, userId, "USER");
          user.userAutoId = getLastAddedUserId() +1 ;
          collectionRef1.document().setData(user.toJson()).catchError((e) {
            print(e);
          });
        }
      });
    });
  }

  getLastAddedUserId() async{
    Query q = collectionRef1.orderBy("user_created_on",descending: true).limit(1);
    QuerySnapshot querySnapshot = await q.getDocuments();
    int oldUserId = querySnapshot.documents[0].data["userAutoId"];
    return oldUserId == null ? querySnapshot.documents[0].data["userAutoId"] : 0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 40.0),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 100.0,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/logo/tricolor.png'),
                                width: 150.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0, left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    allTranslations.text('app_title'),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: Divider(
                                      color: Colors.blueAccent,
                                      height: 30,
                                    ),
                                  ),
                                  Text(
                                    DefaultData.platformTagline,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12.0),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Image(
                      image: AssetImage('assets/images/logo/splash_bg.png'),
                      width: MediaQuery.of(context).size.width,
                    ),
                    (status == AuthStage.INIT)
                        ? Expanded(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                      "Enter your phone number",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 0.0, bottom: 20.0),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: TextField(
                                        keyboardType: TextInputType.number,
                                        maxLength: 10,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (String phone) {
                                          phonenumber = phone;
                                          if (phone.length == 10) {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                          }
                                        },
                                        onSubmitted: (String phone) {
                                          phonenumber = phone;
                                          if (phone.length == 10) {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                          }
                                          // verifyPhoneNumber();
                                        },
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 1.0),
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.blue),
                                          labelText: "Your Mobile Number",
                                          hasFloatingPlaceholder: true,
                                          prefixText: "+91-",
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue)),
                                        ),
                                        autofocus: false),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 10.0, left: 10, right: 10),
                                      child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: FlatButton(
                                            color: Colors.blueAccent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25.0)),
                                            onPressed: () {
                                              // _showDialog(phonenumber);
                                              verifyPhoneNumber();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0,
                                                      horizontal: 12.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    'GET OTP',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Tap to get an OTP and verify',
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
                            ))
                        : Expanded(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                      "Verify number",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 0.0, bottom: 20.0),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: TextField(
                                        controller: otpController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (String code) {
                                          this.smsCode = code;
                                          if (code.length == 6) {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                          }
                                        },
                                        onSubmitted: (String code) {
                                          this.smsCode = code;
                                          if (code.length == 6) {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                          }
                                          // verifyPhoneNumber();
                                        },
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 1.0),
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.blue),
                                          labelText: "OTP (XXXXXX)",
                                          hasFloatingPlaceholder: true,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue)),
                                        ),
                                        autofocus: false),
                                  ),
                                  !isLoading
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              top: 10.0, left: 10, right: 10),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: FlatButton(
                                              color: Colors.blueAccent,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0)),
                                              onPressed: () {
                                                signIn();
                                                // Navigator.pushNamedAndRemoveUntil(
                                                //     context, '/home', (_) => false);
                                                // Navigator.pushReplacement(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (BuildContext context) =>
                                                //             LanguagePreferences()));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12.0,
                                                        horizontal: 12.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      'Verify',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Tap to login/signup',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ))
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              child:
                                                  CircularProgressIndicator(),
                                              height: 20.0,
                                              width: 20.0,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                            ),
                                            Text(
                                              "Waiting for OTP",
                                              style: TextStyle(fontSize: 15),
                                            )
                                          ],
                                        )
                                ],
                              ),
                            ))
                  ],
                )
              ],
            ),
          ),
        ));
    // return Scaffold(
    //     body: SingleChildScrollView(
    //   child: Container(
    //     height: MediaQuery.of(context).size.height,
    //     decoration: BoxDecoration(
    //       // Box decoration takes a gradient
    //       gradient: LinearGradient(
    //         // Where the linear gradient begins and ends
    //         begin: Alignment.topCenter,
    //         end: Alignment.center,
    //         // Add one stop for each color. Stops should increase from 0 to 1
    //         stops: [0.5, 0.5],
    //         tileMode: TileMode.clamp,
    //         colors: [
    //           // Colors are easy thanks to Flutter's Colors class.
    //           Colors.redAccent,
    //           Color(0xFFEEEEEE),
    //         ],
    //       ),
    //     ),
    //     child: Column(
    //       children: <Widget>[
    //         Container(
    //             margin: EdgeInsets.only(top: 80),
    //             child: Column(
    //               children: <Widget>[
    //                 Text(
    //                   'Mobile Verfication',
    //                   style: TextStyle(fontSize: 30.0, color: Colors.white),
    //                 ),
    //                 Text(
    //                   '(OTP Authentication)',
    //                   style: TextStyle(fontSize: 15.0, color: Colors.white),
    //                 ),
    //               ],
    //             )),
    //         Container(
    //           margin: EdgeInsets.only(top: 80),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               (status == AuthStage.INIT)
    //                   ? Container(
    //                       width: 300.0,
    //                       child: TextField(
    //                           keyboardType: TextInputType.number,
    //                           maxLength: 10,
    //                           textInputAction: TextInputAction.done,
    //                           onChanged: (String phone) {
    //                             phonenumber = phone;
    //                           },
    //                           onSubmitted: (String phone) {
    //                             phonenumber = phone;
    //                             verifyPhoneNumber();
    //                           },
    //                           decoration: InputDecoration(
    //                             labelText: "Mobile Number",
    //                             hasFloatingPlaceholder: true,
    //                             prefixText: "+91-",
    //                             border: OutlineInputBorder(
    //                                 borderSide:
    //                                     BorderSide(color: Colors.teal)),
    //                           ),
    //                           autofocus: true),
    //                     )
    //                   : new Container(),
    //             ],
    //           ),
    //         ),
    //         (status == AuthStage.SMS_SENT)
    //             ? Column(
    //                 children: <Widget>[
    //                   Text("Provide OTP sent via SMS"),
    //                   Container(
    //                     margin: EdgeInsets.only(top: 30, bottom: 20),
    //                     child: PinCodeTextField(
    //                       hideCharacter: false,
    //                       highlight: true,
    //                       highlightColor: Colors.orange,
    //                       defaultBorderColor: Colors.grey,
    //                       hasTextBorderColor: Colors.grey,
    //                       maxLength: 6,
    //                       pinBoxHeight: 50.0,
    //                       pinBoxWidth: 50.0,
    //                       pinTextStyle: TextStyle(fontSize: 30.0),
    //                       pinTextAnimatedSwitcherDuration:
    //                           Duration(milliseconds: 500),
    //                       onTextChanged: (String code){
    //                         this.smsCode = code;
    //                       },
    //                     ),
    //                   ),
    //                   FlatButton(
    //                     color: Colors.red,
    //                     onPressed: () {
    //                       _auth.currentUser().then((user){
    //                         if(user != null){
    //                           currentUser = user;
    //                           setState(() {
    //                             status = AuthStage.PHONE_VERIFIED;
    //                           });
    //                         } else {
    //                           signIn();
    //                         }
    //                       });
    //                     },
    //                     shape: new RoundedRectangleBorder(
    //                         borderRadius: new BorderRadius.circular(30.0)),
    //                     child: Padding(
    //                       padding: const EdgeInsets.symmetric(
    //                           vertical: 18.0, horizontal: 98.0),
    //                       child: Text(
    //                         'Verify',
    //                         style: TextStyle(
    //                             color: Colors.white,
    //                             fontSize: 18.0,
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               )
    //             : Column(),
    //         (status == AuthStage.PHONE_VERIFIED)
    //             ? Column(
    //                 children: <Widget>[
    //                   Icon(
    //                     Icons.check_circle,
    //                     color: Colors.green,
    //                     size: 50.0,
    //                   ),
    //                   Text(
    //                     "Mobile number verfied",
    //                     style: TextStyle(
    //                         color: Colors.green, fontWeight: FontWeight.w900),
    //                   ),
    //                 ],
    //               )
    //             : Column(),
    //         (status == AuthStage.PHONE_VERIFIED)
    //             ? FlatButton(
    //                 color: Colors.red,
    //                 onPressed: () {
    //                   Navigator.push(context, MaterialPageRoute(builder: (context) => UserForm(phonenumber: phonenumber, userid: currentUser.uid)));
    //                 },
    //                 shape: new RoundedRectangleBorder(
    //                     borderRadius: new BorderRadius.circular(30.0)),
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(
    //                       vertical: 18.0, horizontal: 98.0),
    //                   child: Text(
    //                     'Proceed',
    //                     style: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 18.0,
    //                         fontWeight: FontWeight.bold),
    //                   ),
    //                 ),
    //               )
    //             : Column(),
    //         (status == AuthStage.PHONE_FAILED)
    //             ? Column(
    //                 children: <Widget>[
    //                   Icon(
    //                     Icons.error_outline,
    //                     color: Colors.red,
    //                     size: 50.0,
    //                   ),
    //                   Text(
    //                     "Invalid OTP! Try again!",
    //                     style: TextStyle(
    //                         color: Colors.red, fontWeight: FontWeight.w900),
    //                   ),
    //                 ],
    //               )
    //             : new Column(),
    //         InkWell(
    //           onTap: () {
    //             Navigator.pop(context);
    //           },
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(
    //                 vertical: 12.0, horizontal: 24.0),
    //             child: Text(
    //               'Go back',
    //               textAlign: TextAlign.end,
    //               style: TextStyle(
    //                   color: Color(0xFF475d9a),
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: 19.0),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ));
  }
}
