import 'package:flutter/material.dart';

class NGOScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register NGO"),
        ),
        body: new Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              title: Text("NGO Registration"),
            ),
            Container(
              // margin: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width - 50,
                    child: new TextField(
                        keyboardType: TextInputType.text,
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
                    width: MediaQuery.of(context).size.width - 50,
                    child: new TextField(
                        keyboardType: TextInputType.emailAddress,
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
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              margin: EdgeInsets.only(left: 10),
              child: FlatButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 58.0),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
