import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutee/services/chat/send_text.dart';
import 'package:flutee/services/storage/save_image.dart';

Future uploadImage(File image, DocumentReference chatRef) async {
  Timestamp t = Timestamp.now();
  String fileName = t.toString();

  saveImage(image, fileName);

  StorageReference storageRef =
      FirebaseStorage.instance.ref().child('images/$fileName');
  StorageUploadTask uploadTask = storageRef.putFile(image);
  StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

  storageTaskSnapshot.ref.getDownloadURL().then((downloadURL) {
    sendText(chatRef, downloadURL, 2, Timestamp.now());
  });
}
