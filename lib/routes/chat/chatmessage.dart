import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {

  final String loggedInUser;
  final String text;
  final String sentBy;
  final String sentId;
  final DateTime sentAt;

  final f =  new DateFormat.yMd().add_jm();
// constructor to get text from textfield
  ChatMessage({
    this.text,
    this.sentBy,
    this.sentId,
    this.sentAt,
    this.loggedInUser
  });

  MainAxisAlignment getAlignmentForMessageByUser(){
    if(this.sentId == this.loggedInUser)
      return MainAxisAlignment.end;
    return MainAxisAlignment.start;
  }
  Widget getName(){
    if(this.sentId == this.loggedInUser) return new Container(width: 0, height: 0);
    return new Container(
      padding: const EdgeInsets.fromLTRB(10,5,10,5),
      child : new Text(
        sentBy,
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.redAccent, fontSize: 14),
      ),
    );
  }
  Decoration getBoxDecorationByUser(){
    return  BoxDecoration(
      color: (this.sentId == this.loggedInUser) ? Colors.white : Colors.lightGreen[100],
      borderRadius: BorderRadius.all(
        Radius.circular(6.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(left:15.0,right: 15.0,bottom: 10),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: getAlignmentForMessageByUser(),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(2.0),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: getBoxDecorationByUser(),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                 getName(),
                  new Container(
                    padding: const EdgeInsets.fromLTRB(10,0,10,5),
                    child: new Text(
                      text,
                      textAlign: TextAlign.left,
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
            ),
          ],
        )
    );
  }
}