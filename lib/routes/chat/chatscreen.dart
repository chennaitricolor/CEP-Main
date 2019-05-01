import 'package:flutter/material.dart';
import 'chatmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatenvironement.dart';

class Record {
  final String message;
  final String sentBy;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['message'] != null),
        assert(map['sentBy'] != null),
        message = map['message'],
        sentBy = map['sentBy'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$message:$sentBy>";
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('wards')
          .document('ward-2')
          .collection('messages')
          .orderBy('sentAt')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return ChatMessage(text:record.message, sentBy: record.sentBy,);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(
        children: <Widget>[
          new Flexible(
            child: _buildBody(context)
          ),
          new Divider(
            height: 1.0,
          ),
          new Container(decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
            child: ChatEnvironment(),)
        ],
      )
    );
  }
}
