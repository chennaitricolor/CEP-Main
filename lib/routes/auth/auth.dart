import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:namma_chennai/routes/form/userform.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';
import 'package:namma_chennai/locale/all_translations.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final SharedPrefs _sharedPrefs = new SharedPrefs();

class Auth extends StatefulWidget {
  @override
  AuthState createState() => AuthState();
}

enum AuthStage {
  INIT,
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
  AuthStage status = AuthStage.PHONE_VERIFIED;
  String prefLang = "Language";

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
  void initState() {
    super.initState();

    _sharedPrefs.getApplicationSavedInformation("language").then((val) {
      setState(() {
        prefLang = val;
      });
    });
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
            Container(
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Mobile Verfication \n' + prefLang + " " + allTranslations.text("app_title"),
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
                    Text(
                      '(OTP Authentication)',
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (status == AuthStage.INIT)
                      ? new Container(
                          width: 300.0,
                          child: new TextField(
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
                ],
              ),
            ),
            (status == AuthStage.PHONE_ENTERED)
                ? Column(
                    children: <Widget>[
                      new Text("Provide OTP sent via SMS"),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 50),
                        child: PinCodeTextField(
                          hideCharacter: false,
                          highlight: true,
                          highlightColor: Colors.orange,
                          defaultBorderColor: Colors.grey,
                          hasTextBorderColor: Colors.grey,
                          maxLength: 6,
                          pinBoxHeight: 50.0,
                          pinBoxWidth: 50.0,
                          pinTextStyle: TextStyle(fontSize: 30.0),
                          pinTextAnimatedSwitcherDuration:
                              Duration(milliseconds: 500),
                        ),
                      ),
                    ],
                  )
                : new Column(),
            (status == AuthStage.PHONE_VERIFIED)
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
            (status == AuthStage.PHONE_FAILED)
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
                        "Invalid OTP! Try again!",
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserForm(phonenumber: phonenumber)));
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
