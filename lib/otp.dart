import 'package:flutter/material.dart';
import 'package:namma_chennai/locale/allTranslations.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => new _OTPState();
}

class _OTPState extends State<OTP> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: 300.0,
                  child: new TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      textInputAction: TextInputAction.send,
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
                            borderSide: new BorderSide(color: Colors.teal)),
                      ),
                      autofocus: true),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
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
              pinTextAnimatedSwitcherDuration: Duration(milliseconds: 500),
            ),
            SizedBox(
              height: 50,
            ),
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
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 50,
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () {
                Navigator.pushNamed(context, "/form");
                // Navigator.pushNamedAndRemoveUntil(
                //     context, '/dashboard', (_) => false);
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 98.0),
                child: Text(
                  'Signup',
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
