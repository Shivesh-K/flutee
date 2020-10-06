import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutee/screens/ChatScreen/chat_screen.dart';
import 'package:flutee/services/chat/new_chat.dart';
import 'package:flutter/material.dart';

Widget newChatFAB(BuildContext context, User user) {
  return FloatingActionButton(
    child: Icon(Icons.add),
    onPressed: () => onNewChat(context, user),
  );
}

void onNewChat(BuildContext context, User user) async {
  TextEditingController textEditingController = TextEditingController();

  final String email = await showDialog<String>(
    context: context,
    child: AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'Email ID', hintText: 'eg. john.doe@gmail.com'),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context, '');
            }),
        new MaterialButton(
            child: Text('SUBMIT'),
            onPressed: () {
              Navigator.pop(context, textEditingController.text);
            })
      ],
    ),
  );

  if (email == null || email.trim() == '') return;

  final DocumentSnapshot peerSnap = await getUserSnapFromEmail(email);
  final DocumentReference chatRef = await createNewChat(peerSnap, user);

  if (chatRef == null) {
    Builder(
      builder: (context) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('No such user exists.')));
        return Center();
      },
    );
    return;
  }

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChatScreen(
                chatRef: chatRef,
                peerSnap: peerSnap,
              )));
}

Future<DocumentSnapshot> getUserSnapFromEmail(String email) async {
  final QuerySnapshot q = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get();
  if (q.docs.length == 0) return null;
  return q.docs[0];
}
