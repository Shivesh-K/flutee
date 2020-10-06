import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutee/screens/AuthScreen/auth_screen.dart';
import 'package:flutee/services/authentication/sign_in_google.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'chat_list_item.dart';
import 'new_chat_fab.dart';

class ChatListScreen extends StatelessWidget {
  final User user;

  ChatListScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.user == null
        ? Text('Login failed!')
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('chats')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Flutee'),
                  actions: <Widget>[
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.signOutAlt),
                      onPressed: () {
                        signOutGoogle();
                        Future.delayed(Duration.zero, () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthScreen()));
                        });
                      },
                    )
                  ],
                ),
                body: !snapshot.hasData
                    ? Center(child: CircularProgressIndicator())
                    : ((snapshot.data.size == 0)
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.all_inclusive,
                                  size: 128.0,
                                  color: Colors.grey[700],
                                ),
                                Text(
                                  'No chats yet!',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          )
                        : ListView.builder(
                            // itemCount: snapshot.data.length,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot chatSnap =
                                  snapshot.data.docs[index];
                              return FutureBuilder(
                                future: listItem(context, chatSnap),
                                builder: (context, snapshot) => snapshot.hasData
                                    ? snapshot.data
                                    : Container(),
                              );
                            },
                          )),
                floatingActionButton: FloatingActionButton(
                  child: FaIcon(FontAwesomeIcons.plus),
                  onPressed: () => onNewChat(context, user),
                ),
                bottomNavigationBar: null,
              );
            });
  }
}
