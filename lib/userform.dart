import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => new _UserFormState();
}

class _UserFormState extends State<UserForm> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
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
        child: new Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            new Text(
              'Hi, Welcome to Namma Chennai',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25.0,
                  color: Colors.yellow),
            ),
            SizedBox(
              height: 10,
            ),
            new Text(
              'Provide additional information to understand you better',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
            SizedBox(
              height: 100,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: 300.0,
                  child: new TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        labelText: "Name",
                        hasFloatingPlaceholder: true,
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                      ),
                      autofocus: true),
                ),
                SizedBox(
                  height: 10,
                ),
                new Container(
                  width: 300.0,
                  child: new TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hasFloatingPlaceholder: true,
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                      ),
                      autofocus: true),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            
            SizedBox(
              height: 50,
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () async {
                // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                // print(position.latitude);
                // print(position.longitude);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/dashboard', (_) => false);
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 58.0),
                child: Text(
                  'Proceed to dashboard',
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
    );
  }
}