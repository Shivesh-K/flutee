import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutee/screens/ChatScreen/chat_screen.dart';
import 'package:flutter/material.dart';

Future<Widget> listItem(
    BuildContext context, DocumentSnapshot userChatSnap) async {
  final DocumentSnapshot peerSnap = await FirebaseFirestore.instance
      .collection('users')
      .doc(userChatSnap.data()['receiverId'])
      .get();

  return InkWell(
    child: Container(
      child: ListTile(
        title: Text(peerSnap.data()['name']),
        subtitle: Text(peerSnap.data()['email']),
        leading: Hero(
          tag: peerSnap.data()['id'],
          child: CircleAvatar(
            child: ClipOval(child: Image.network(peerSnap.data()['photoUrl'])),
            backgroundColor: Colors.tealAccent,
            radius: 24.0,
            // child: Image(image: ge,),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.0),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(width: 0.35))),
    ),
    onTap: () async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ChatScreen(
              chatRef: userChatSnap.data()['chatRef'],
              peerSnap: peerSnap,
            );
          },
        ),
      );
    },
  );
}
