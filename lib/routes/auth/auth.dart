import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:namma_chennai/routes/form/userform.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final SharedPrefs _sharedPrefs = new SharedPrefs();

class Auth extends StatefulWidget {
  @override
  AuthState createState() => AuthState();
}

enum AuthStage {
  INIT,
  SMS_SENT,
  SMS_TIMEOUT,
  PHONE_VERIFIED,
  PHONE_FAILED
}

class AuthState extends State<Auth> {
  String verificationId;
  String smsCode;
  String phonenumber;
  AuthStage status = AuthStage.INIT;
  String prefLang = "Language";

  Future<void> verifyPhoneNumber() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
      setState(() {
        status = AuthStage.SMS_TIMEOUT;
      });
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      this.verificationId = verId;
      setState(() {
        status = AuthStage.SMS_SENT;
      });
    };

    final PhoneVerificationCompleted verificationCompleted = (FirebaseUser user) {
      setState(() {
        status = AuthStage.PHONE_VERIFIED;
      });
    };

    final PhoneVerificationFailed verificationFailed = (AuthException exception) {
      print(exception.message + " " + exception.code);
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
      verificationFailed: verificationFailed
    );
  }

  signIn(){
    _auth.signInWithPhoneNumber(verificationId: this.verificationId, smsCode: this.smsCode)
    .then((user) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserForm(phonenumber: phonenumber)));
    }).catchError((e){
      print(e);
    });
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
    return Scaffold(
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
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 80),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Mobile Verfication',
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
                    Text(
                      '(OTP Authentication)',
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (status == AuthStage.INIT)
                      ? Container(
                          width: 300.0,
                          child: TextField(
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              textInputAction: TextInputAction.send,
                              onChanged: (String phone) {
                                phonenumber = phone;
                              },
                              onSubmitted: (String phone) {
                                phonenumber = phone;
                                verifyPhoneNumber();
                              },
                              decoration: InputDecoration(
                                labelText: "Mobile Number",
                                hasFloatingPlaceholder: true,
                                prefixText: "+91-",
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.teal)),
                              ),
                              autofocus: true),
                        )
                      : new Container(),
                ],
              ),
            ),
            (status == AuthStage.SMS_SENT)
                ? Column(
                    children: <Widget>[
                      Text("Provide OTP sent via SMS"),
                      Container(
                        margin: EdgeInsets.only(top: 30, bottom: 20),
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
                          onTextChanged: (String code){
                            this.smsCode = code;
                          },
                        ),
                      ),
                      FlatButton(
                        color: Colors.red,
                        onPressed: () {
                          _auth.currentUser().then((user){
                            if(user != null){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserForm(phonenumber: phonenumber)));
                            } else {
                              signIn();
                            }
                          });
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
                      )
                    ],
                  )
                : Column(),
            (status == AuthStage.PHONE_VERIFIED)
                ? Column(
                    children: <Widget>[
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 50.0,
                      ),
                      Text(
                        "Mobile number verfied",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w900),
                      ),
                    ],
                  )
                : Column(),
            (status == AuthStage.PHONE_FAILED)
                ? Column(
                    children: <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 50.0,
                      ),
                      Text(
                        "Invalid OTP! Try again!",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w900),
                      ),
                    ],
                  )
                : new Column(),
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
