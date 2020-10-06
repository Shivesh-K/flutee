import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<DocumentReference> sendText(
    DocumentReference chatRef, String text, int type, Timestamp t) {
  if (text.trim() == '') return null;
  Object o = {
    'type': type,
    'text': text,
    'timestamp': t,
    'sender': FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid),
  };
  return chatRef.collection('messages').add(o);
}
