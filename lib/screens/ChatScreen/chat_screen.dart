import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bottom_input.dart';
import 'main_view.dart';

class ChatScreen extends StatefulWidget {
  final DocumentReference chatRef;
  final DocumentSnapshot peerSnap;

  ChatScreen({Key key, @required this.chatRef, @required this.peerSnap})
      : super(key: key);

  @override
  _ChatScreenState createState() =>
      _ChatScreenState(chatRef: chatRef, peerSnap: peerSnap);
}

class _ChatScreenState extends State<ChatScreen> {
  final DocumentReference chatRef;
  final DocumentSnapshot peerSnap;

  _ChatScreenState({this.chatRef, this.peerSnap});

  @override
  void initState() {
    // getUsers(chatRef).then((users) {
    //   currentUser = users[0];
    //   peerUser = users[1];
    //   peerUser.get().then((userSnap) {
    //     peerUserSnap = userSnap;
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Center(
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.chevronLeft),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Row(
          children: [
            Hero(
              tag: peerSnap.data()['id'],
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.tealAccent,
                child: ClipOval(
                  child: Image.network(peerSnap.data()['photoUrl']),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(peerSnap.data()['name']),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: MainView(
              chatRef: chatRef,
            ),
          ),
          BottomInput(chatRef: chatRef),
        ],
      ),
    );
  }
}

Future<List<DocumentReference>> getUsers(DocumentReference chatRef) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DocumentSnapshot chatSnap = await chatRef.get();
  final DocumentReference user1 = chatSnap.data()['user1'];
  final DocumentReference user2 = chatSnap.data()['user2'];

  if (_auth.currentUser.uid == user1.id) {
    return [user1, user2];
  } else {
    return [user2, user1];
  }
}
