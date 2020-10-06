import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutee/services/chat/send_text.dart';
import 'package:flutee/services/chat/upload_file.dart';
import 'package:flutee/services/chat/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class BottomInput extends StatefulWidget {
  final DocumentReference chatRef;

  BottomInput({Key key, this.chatRef}) : super(key: key);

  @override
  _BottomInputState createState() => _BottomInputState();
}

class _BottomInputState extends State<BottomInput>
    with TickerProviderStateMixin {
  bool isTyping = false;
  final TextEditingController textEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      width: double.infinity,
      height: 60.0,
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: <Widget>[
          // Button send image
          Visibility(
            visible: !isTyping,
            child: Container(
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.image),
                onPressed: () => sendImage(widget.chatRef),
              ),
            ),
          ),

          // Edit text
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                cursorColor: Colors.tealAccent,
                maxLines: null,
                onSubmitted: (value) {
                  sendText(widget.chatRef, textEditingController.text, 1,
                      Timestamp.now());
                  textEditingController.clear();
                },
                onChanged: (value) {
                  setState(() {
                    isTyping = (value.trim() != '');
                  });
                },
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),

          // Button send image
          Visibility(
            visible: !isTyping,
            child: Container(
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.paperclip),
                onPressed: () => sendFile(widget.chatRef),
              ),
            ),
          ),

          VerticalDivider(color: Colors.black),

          // Button send message
          Container(
            margin: EdgeInsets.only(right: 8.0),
            child: IconButton(
              focusColor: Colors.tealAccent,
              icon: FaIcon(FontAwesomeIcons.paperPlane),
              onPressed: () {
                sendText(widget.chatRef, textEditingController.text, 1,
                    Timestamp.now());
                textEditingController.clear();
                setState(() {
                  isTyping = false;
                });
              },
              // color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

Future sendImage(DocumentReference chatRef) async {
  PickedFile pickedImage =
      await ImagePicker().getImage(source: ImageSource.gallery);
  if (pickedImage == null) return;
  File image = File(pickedImage.path);

  if (image != null) {
    uploadImage(image, chatRef);
  }
}

Future sendFile(DocumentReference chatRef) async {
  FilePickerResult pickedFile = await FilePicker.platform.pickFiles();
  if (pickedFile == null) return;
  File file = File(pickedFile.files[0].path);

  if (file != null) {
    uploadFile(file, chatRef);
  }
}
