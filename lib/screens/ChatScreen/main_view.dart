import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class MainView extends StatefulWidget {
  final DocumentReference chatRef;

  const MainView({Key key, this.chatRef}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.chatRef
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        return !(snapshot.hasData)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) =>
                    buildMessage(snapshot.data.docs[index]),
              );
      },
    );
  }
}

Widget buildMessage(DocumentSnapshot messageSnap) {
  final Map messageData = messageSnap.data();
  final bool isSenderCurrentUser =
      FirebaseAuth.instance.currentUser.uid == (messageData['sender']).id;
  return Container(
    alignment:
        isSenderCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.only(
          left: isSenderCurrentUser ? 64 : 8,
          right: isSenderCurrentUser ? 8 : 64,
          top: 2,
          bottom: 2),
      padding: EdgeInsets.all(6),
      // width: ,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSenderCurrentUser ? Colors.transparent : Colors.tealAccent,
        border: isSenderCurrentUser
            ? Border.all(width: 0.35, color: Colors.tealAccent)
            : Border.all(width: 0),
      ),
      child: Column(
        children: [
          getMessageBody(messageData, isSenderCurrentUser),
          Text(
            DateFormat('MMM d, HH:mm')
                .format(messageData['timestamp'].toDate()),
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: isSenderCurrentUser ? Colors.white30 : Colors.black38),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    ),
  );
}

Widget getMessageBody(Map messageData, bool isSenderCurrentUser) {
  switch (messageData['type']) {
    case 1:
      return Text(
        messageData['text'],
        style: TextStyle(
            color: isSenderCurrentUser ? Colors.tealAccent : Colors.black,
            fontSize: 16),
        textAlign: TextAlign.left,
      );
    case 2:
      return FutureBuilder(
        future: loadImage(messageData),
        builder: (context, snapshot) => snapshot.hasData
            ? snapshot.data
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.image),
                  CircularProgressIndicator(),
                ],
              ),
      );
    case 3:
      return Container(
        padding: EdgeInsets.only(left: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.file),
                SizedBox(
                  width: 8,
                ),
                Text('File'),
                SizedBox(
                  width: 8,
                )
              ],
            ),
            FutureBuilder(
              future: isDownloaded(messageData),
              builder: (context, snapshot) => snapshot.hasData
                  ? (!(snapshot.data)
                      ? IconButton(
                          icon: FaIcon(FontAwesomeIcons.download),
                          onPressed: () {
                            downloadFile(messageData);
                          },
                        )
                      : SizedBox(
                          width: 0,
                        ))
                  : SizedBox(
                      width: 0,
                    ),
            )
          ],
        ),
      );
    default:
      return null;
  }
}

Future<Widget> loadImage(Map messageData) async {
  // Getting name of the image file
  final StorageReference storageRef =
      await FirebaseStorage.instance.getReferenceFromUrl(messageData['text']);
  final String fileName = await storageRef.getName();

  // Getting the directory for images
  final d = Directory('${(await getExternalStorageDirectory()).path}/images');

  // If the image is already on the device then load it locally
  if (await File('${d.path}/$fileName').exists()) {
    return Image.file(File('${d.path}/$fileName'));
  }
  // Else download the image, save it locally and then load it.
  else {
    final http.Response res = await http.get(messageData['text']);
    final Directory d = await getExternalStorageDirectory();
    await Directory('${d.path}/images').create(recursive: true);
    File('${d.path}/images/$fileName').writeAsBytesSync(res.bodyBytes);
    return Image.file(File('${d.path}/images/$fileName'));
  }
}

Future<bool> isDownloaded(Map messageData) async {
  final StorageReference storageRef =
      await FirebaseStorage.instance.getReferenceFromUrl(messageData['text']);
  final String fileName = await storageRef.getName();

  // Getting the directory for files
  final d =
      Directory('${(await getExternalStorageDirectory()).path}/documents');

  return (await File('${d.path}/$fileName').exists());
}

Future<void> downloadFile(Map messageData) async {
  final StorageReference storageRef =
      await FirebaseStorage.instance.getReferenceFromUrl(messageData['text']);
  final String fileName = await storageRef.getName();
  final http.Response res = await http.get(messageData['text']);
  final Directory d = await getExternalStorageDirectory();
  await Directory('${d.path}/documents').create(recursive: true);

  File('${d.path}/documents/$fileName').writeAsBytesSync(res.bodyBytes);
}
