import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String message;
  final String sentBy;
  final String sentAt;
  final Timestamp sentTime;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['message'] != null),
        assert(map['sentBy'] != null),
        assert(map['sentAt'] != null),
        message = map['message'],
        sentBy = map['sentBy'],
        sentAt = map['sentAt'].toString(),
        sentTime=map['sentAt'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$message:$sentBy>";
}
