import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namma_chennai/locale/allTranslations.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => new _OTPState();
}

class _OTPState extends State<OTP> {
  Map<String, bool> _fieldIndicator = {
    "showMobileNo": true,
    "showOTP": false,
    "showVerified": false,
    "showNotVerified": false
  };

  String statusMessage = "====";
  var mobileNo = "";

  // Firebase Verification
  String smsCode;
  String verificationId;
  Future<void> _testVerifyPhoneNumber() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      setState(() {
        statusMessage = verId;
      });
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      setState(() {
        statusMessage = "Signed in";
      });
      print('Signed in');
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      setState(() {
        statusMessage = "verified";
      });
      print('verified');
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      setState(() {
        statusMessage = '${exception.message}';
      });
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91 " + mobileNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  void submit() {
    print(mobileNo);

    if (_fieldIndicator["showMobileNo"]) {
      print("here");
      setState(() {
        _fieldIndicator["showMobileNo"] = false;
        _fieldIndicator["showOTP"] = true;
      });
      _testVerifyPhoneNumber();
    } else if (_fieldIndicator["showOTP"]) {
      setState(() {
        _fieldIndicator["showOTP"] = false;
        if (true) {
          _fieldIndicator["showVerified"] = true;
          _fieldIndicator["showNotVerified"] = false;
        } else {
          _fieldIndicator["showNotVerified"] = true;
          _fieldIndicator["showVerified"] = false;
        }
      });
    } else if (_fieldIndicator["showVerified"]) {
      setState(() {
        _fieldIndicator["showVerified"] = false;
      });
      Navigator.pushNamed(context, "/form");
    } else if (_fieldIndicator["showNotVerified"]) {
      setState(() {
        _fieldIndicator["showNotVerified"] = false;
      });
    }
    // Navigator.pushNamed(context, "/form");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
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
        child: new Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            new Text(
              'Mobile Verfication',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30.0,
                  color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            new Text(
              'OTP Authentication',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
            SizedBox(
              height: 100,
            ),
            new Text("$statusMessage"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _fieldIndicator["showMobileNo"]
                    ? new Container(
                        width: 300.0,
                        child: new TextField(
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (String no) {
                              print(no);
                            },
                            onChanged: (String no) {
                              setState(() {
                                mobileNo = no;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Mobile Number",
                              hasFloatingPlaceholder: true,
                              prefixText: "+91-",
                              suffixStyle: TextStyle(color: Colors.green),
                              suffixIcon: Icon(
                                Icons.verified_user,
                                color: Colors.green,
                              ),
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                            ),
                            autofocus: true),
                      )
                    : new Container(),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            _fieldIndicator["showOTP"]
                ? Column(
                    children: <Widget>[
                      new Text("Provide OTP sent via SMS"),
                      SizedBox(
                        height: 10,
                      ),
                      PinCodeTextField(
                        hideCharacter: false,
                        highlight: true,
                        highlightColor: Colors.orange,
                        defaultBorderColor: Colors.grey,
                        hasTextBorderColor: Colors.grey,
                        maxLength: 4,
                        pinBoxHeight: 50.0,
                        pinBoxWidth: 50.0,
                        pinTextStyle: TextStyle(fontSize: 30.0),
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 500),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )
                : new Column(),
            _fieldIndicator["showVerified"]
                ? Column(
                    children: <Widget>[
                      new Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 50.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      new Text(
                        "Mobile number verfied",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )
                : new Column(),
            _fieldIndicator["showNotVerified"]
                ? Column(
                    children: <Widget>[
                      new Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 50.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      new Text(
                        "Invalid OTP! Try again! ${_fieldIndicator['showVerified']}",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )
                : new Column(),
            FlatButton(
              color: Colors.red,
              onPressed: () {
                submit();
                // Navigator.pushNamedAndRemoveUntil(
                //     context, '/dashboard', (_) => false);
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
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
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                child: Text(
                  'Go back',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Color(0xFF475d9a),
                      fontWeight: FontWeight.w700,
                      fontSize: 19.0),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
