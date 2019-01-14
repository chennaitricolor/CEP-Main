import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:namma_chennai/routes/form/userform.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Auth extends StatefulWidget {
  @override
  AuthState createState() => AuthState();
}

enum AuthStage {
  PHONE_ENTERED,
  SMS_SENT,
  SMS_TIMEOUT,
  PHONE_VERIFIED,
  PHONE_FAILED
}

class AuthState extends State<Auth> {
  String verificationId;
  String testSmsCode;
  String phonenumber;
  AuthStage status;

  Future<void> verifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      setState(() {
        status = AuthStage.PHONE_VERIFIED;
        print(status);
        Navigator.pushNamed(context, "/form");
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        status = AuthStage.PHONE_FAILED;
        print(status);
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      setState(() {
        status = AuthStage.SMS_SENT;
        print(status);
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      setState(() {
        status = AuthStage.SMS_TIMEOUT;
        print(status);
      });
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phonenumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
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
              'Mobile Verification',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30.0,
                  color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(top: 70.0),
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
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (String phone) {
                        phonenumber = phone;
                        status = AuthStage.PHONE_ENTERED;
                        verifyPhoneNumber();
                      },
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        hasFloatingPlaceholder: true,
                        prefixText: "+91-",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      ),
                      autofocus: true),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: new Container(
                color: Colors.transparent,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300.0,
                  child: Text(
                    "Sending SMS...",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300.0,
                  child: Text(
                    "SMS Sent!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: new Container(
                color: Colors.transparent,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PinCodeTextField(
                  hideCharacter: false,
                  highlight: true,
                  highlightColor: Colors.red,
                  defaultBorderColor: Colors.grey,
                  hasTextBorderColor: Colors.grey,
                  maxLength: 6,
                  pinBoxHeight: 40.0,
                  pinBoxWidth: 40.0,
                  pinTextStyle: TextStyle(fontSize: 20.0),
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 500),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserForm(phonenumber: phonenumber)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 98.0),
                    child: Text(
                      'Verify',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
