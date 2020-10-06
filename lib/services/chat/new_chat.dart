import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<DocumentReference> createNewChat(
    DocumentSnapshot otherUserSnap, User currentUser) async {
  if (otherUserSnap == null) {
    return null;
  } else {
    //Getting snapshots of both the users' documents in users collection
    final DocumentSnapshot user1 = otherUserSnap;
    final DocumentSnapshot user2 =
        await _firestore.collection('users').doc(currentUser.uid).get();

    // Getting chatid generated from the users' uid
    String chatid = getChatid(user1, user2);
    final DocumentReference chatRef =
        _firestore.collection('chats').doc(chatid);

    final batch = _firestore.batch();

    batch.set(user1.reference.collection('chats').doc(chatid), {
      'chatRef': chatRef,
      'receiverId': user2.data()['id'],
      'receiverEmail': user2.data()['email'],
      'receiverName': user2.data()['name'],
    });
    batch.set(user2.reference.collection('chats').doc(chatid), {
      'chatRef': chatRef,
      'receiverId': user1.data()['id'],
      'receiverEmail': user1.data()['email'],
      'receiverName': user1.data()['name'],
    });
    batch.set(
        _firestore.collection('chats').doc(chatid),
        {'user1': user1.reference, 'user2': user2.reference},
        SetOptions(merge: true));

    await batch.commit();

    return chatRef;
  }
}

String getChatid(DocumentSnapshot user1, DocumentSnapshot user2) {
  int comparision = user1.data()['id'].compareTo(user2.data()['id']);
  if (comparision > 0) {
    return '${user1.data()['id']}-${user2.data()['id']}';
  } else {
    return '${user2.data()['id']}-${user1.data()['id']}';
  }
}
