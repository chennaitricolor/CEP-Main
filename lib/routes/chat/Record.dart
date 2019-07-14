import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String message;
  final String sentBy;
  final Timestamp sentTime;
  final String sentId;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['message'] != null),
        assert(map['sentBy'] != null),
        assert(map['sentAt'] != null),
        assert(map['sentId'] != null),
        message = map['message'],
        sentBy = map['sentBy'],
        sentTime=map['sentAt'],
        sentId=map['sentId'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$message:$sentBy>";
}
