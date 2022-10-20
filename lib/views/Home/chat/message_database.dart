import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epanty_mobility/model/message.dart';

class MessageDatabaseService {

  List<Message> _messageListFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _messageFromSnapshot(doc);
    }).toList();
  }

  Message _messageFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("message not found");
    return Message.fromMap(data);
  }

  Stream<List<Message>> getMessage(int limit) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc("${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}")
        .collection("dailyMessages")
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots().map(_messageListFromSnapshot);
  }

  void onSendMessage(Message message) {
    var documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc("${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}")
        .collection("dailyMessages")
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference,message.toHashMap());
    });
  }
}
