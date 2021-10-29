import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/components/comment_bubble.dart';
import 'package:gender_app/components/constants.dart';

class CommentStream extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String reportCaseId;
  CommentStream({required this.reportCaseId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection(reportCase_text).doc(reportCaseId).collection(Comment_text).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<CommentBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data() as Map;
          final messageSender = messageText['sender'];
          final messageBubble = CommentBubble(
            sender: messageSender,
            text: messageText['text'],
          );
          messageBubbles.add(messageBubble);
        }
        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: messageBubbles,
        );
      },
    );
  }
}