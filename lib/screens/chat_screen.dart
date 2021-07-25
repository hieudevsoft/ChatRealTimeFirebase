import 'dart:async';
import 'dart:collection';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _textEditingController;
  late final FirebaseFirestore _firestore;
  late final FirebaseAuth _auth;
  late final User? _currentUser;
  late final ScrollController _scrollController;
  late String _message;
  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    if (getCurrentUser() != null) {
      _currentUser = getCurrentUser();
      _firestore = FirebaseFirestore.instance;
      _textEditingController = TextEditingController();
      _scrollController = ScrollController();
    }
    super.initState();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  String getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formatted = formatter.format(now);
    return formatted;
  }

  String getTimeStamp() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              }),
        ],
        centerTitle: true,
        title: Text(
          'Chat',
          style: TextStyle(fontFamily: 'Roboto'),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("messages")
                    .orderBy('time_stamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<MessageWidget> messagesWidgets = [];
                  if (snapshot.hasData) {
                    final messages = snapshot.data!.docs;
                    for (var message in messages) {
                      final messageText = message["message"];
                      final messageSender = message['sender'];
                      final messageTime = message['time_up'];

                      final textWidget = MessageWidget(
                        text: messageText,
                        sender: messageSender,
                        time: messageTime,
                        isMe: _currentUser!.email == messageSender,
                      );
                      messagesWidgets.add(textWidget);
                    }
                  } else {
                    return LinearProgressIndicator();
                  }
                  if (snapshot.hasError) print(snapshot.error.toString());

                  return Expanded(
                    child: ListView(
                      controller: _scrollController,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      children: messagesWidgets,
                    ),
                  );
                }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: kMessageContainerDecoration,
              child: Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        maxLines: 20,
                        minLines: 1,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          _message = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    MaterialButton(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      focusElevation: 5,
                      textColor: Colors.lightBlue,
                      color: Colors.black12,
                      onPressed: () {
                        if (_currentUser != null) {
                          _textEditingController.clear();
                          Map<String, dynamic> message = Map<String, dynamic>();
                          message.addAll({
                            'message': _message,
                            'sender': _currentUser?.email,
                            'time_up': getDate(),
                            'time_stamp': getTimeStamp(),
                          });
                          _firestore.collection("messages").add(message);
                          Timer(
                              Duration(milliseconds: 500),
                              () => _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent));
                        }
                      },
                      child: Text(
                        'Send',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  MessageWidget(
      {required this.text,
      required this.sender,
      required this.time,
      required this.isMe});
  final String text;
  final String sender;
  final String time;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          TyperAnimatedTextKit(
            isRepeatingAnimation: true,
            displayFullTextOnTap: false,
            repeatForever: true,
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w600),
            curve: Curves.decelerate,
            text: ["$sender($time)"],
          ),
          Material(
            shadowColor: Colors.white70,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white, fontSize: 14, fontFamily: 'Roboto'),
              ),
            ),
            color: isMe ? Colors.lightBlueAccent : Colors.black,
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
          ),
        ],
      ),
    );
  }
}
