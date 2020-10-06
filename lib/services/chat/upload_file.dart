import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutee/services/chat/send_text.dart';
import 'package:flutee/services/storage/save_file.dart';

Future uploadFile(File file, DocumentReference chatRef) async {
  Timestamp t = Timestamp.now();
  String fileName = t.toString();

  saveFile(file, fileName);

  StorageReference storageRef =
      FirebaseStorage.instance.ref().child('documents/$fileName');
  StorageUploadTask uploadTask = storageRef.putFile(file);
  StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

  storageTaskSnapshot.ref.getDownloadURL().then((downloadURL) {
    sendText(chatRef, downloadURL, 3, Timestamp.now());
  });
}
