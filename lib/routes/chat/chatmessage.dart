import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String sentBy;
  final String sentAt;
  final Color otherMessageColor =  Colors.lightBlue[100];
  final Color selfMessageColor =  Colors.white;
  final selfMessageMargin =  new EdgeInsets.only(left:50,right: 5.0,bottom: 10);
  final otherMessageMargin =  new EdgeInsets.only(left: 5.0, right: 50,bottom: 10);

// constructor to get text from textfield
  ChatMessage({
    this.text,
    this.sentBy,
    this.sentAt
  });

  EdgeInsets getMarginForTheMessage(sentby){
    return sentby == "author" ? otherMessageMargin : selfMessageMargin;
  }

  Color getColorForTheMessage(sentby){
    return sentby == "author" ? selfMessageColor : otherMessageColor;
  }


  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: getMarginForTheMessage(this.sentBy),
        decoration: new BoxDecoration(
            color: getColorForTheMessage(sentBy),
            borderRadius: BorderRadius.all(new Radius.circular(5))
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.fromLTRB(10,5,10,5),
              child : new Text(
                sentBy,
                style: TextStyle(color: Colors.redAccent, fontSize: 14 ),
              ),
            ),
            new Container(
              padding: const EdgeInsets.fromLTRB(10,0,10,5),
              child: new Text(
                text,
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            new Container(
              padding: const EdgeInsets.fromLTRB(10,0,10,5),
              child: new Text(
                "1/1/2012",
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey,fontSize: 12),
              ),
            )
          ],
        )
    );
  }
}