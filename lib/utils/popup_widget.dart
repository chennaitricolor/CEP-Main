import 'package:flutter/material.dart';

class PopupWidget {
  void show(BuildContext context, String content, {String type = "Alert"}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(type),
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

  void showLoading(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new Dialog(
            child: Container(
              padding: EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: new Text(message),
              ),
            ],
          ),
        ));
      },
    );
  }

  void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}
