
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:loin_with_auth/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';


final _firestore = FirebaseFirestore.instance;
User loggedInUser;
class ChatScreen extends StatefulWidget {
  static const String id = "/chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;


  String messageText;
  TextEditingController messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {

                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore.collection("messages").add(
                          {"text": messageText, "sender": loggedInUser.email,'createdOn':FieldValue.serverTimestamp()});

                      messageTextController.clear();

                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // StreamBuilder<QuerySnapshot> buildStreamBuilder() {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: _fireStore.collection("messages").snapshots(),
  //       // ignore: missing_return
  //       builder: (context, snapShot) {
  //         if (!snapShot.hasData) {
  //           return Center(
  //               child: CircularProgressIndicator(
  //             backgroundColor: Colors.blueAccent,
  //           ));
  //         }
  //         final messages = snapShot.data.docs.reversed;
  //
  //         List<Message> messagesList = [];
  //
  //         for (var message in messages) {
  //           final messageSender = message.data()["sender"];
  //           final messageText = message.data()["text"];
  //           final currentUser = loggedInUser.email;
  //
  //           var m = Message(
  //               messageSender, messageText, currentUser == messageSender);
  //           messagesList.add(m);
  //           // messagesList.reversed;
  //
  //         }
  //
  //         return Expanded(
  //           child: ListView(
  //             reverse: true,
  //             padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
  //             children: messagesList,
  //           ),
  //         );
  //
  //         // return Expanded(
  //         //   child: ListView.builder(
  //         //     reverse: true,
  //         //     //  padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
  //         //     itemCount: messagesList.length,
  //         //     itemBuilder: (c, i) {
  //         //       return buildCard(messagesList, i);
  //         //     },
  //         //   ),
  //         // );
  //       });
  // }
}
class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy("createdOn",descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

