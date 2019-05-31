import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {

  final String loggedInUser;
  final String text;
  final String sentBy;
  final DateTime sentAt;
//  final Color selfMessageColor =  const Color(0xffDAF7A6)
  final Color selfMessageColor =  Colors.green[100];
  final Color otherMessageColor =  Colors.white;
  final selfMessageMargin =  new EdgeInsets.only(left:50,right: 5.0,bottom: 10);
  final otherMessageMargin =  new EdgeInsets.only(left: 5.0, right: 50,bottom: 10);

  final f =  new DateFormat.yMd().add_jm();
// constructor to get text from textfield
  ChatMessage({
    this.text,
    this.sentBy,
    this.sentAt,
    this.loggedInUser
  });

  EdgeInsets getMarginForTheMessage(sentby){
    return sentby == this.loggedInUser? selfMessageMargin : otherMessageMargin;
  }

  Color getColorForTheMessage(sentby){
    return sentby == this.loggedInUser ? otherMessageColor : selfMessageColor;
  }


  @override
  Widget build(BuildContext context) {
    return new Container(

        margin: getMarginForTheMessage(this.sentBy),
        decoration: new BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black,
//                offset: Offset(1.0, 6.0),
                blurRadius: 0.1,
              ),
            ],
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
                f.format(sentAt),
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey,fontSize: 12),
              ),
            )
          ],
        )
    );
  }
}