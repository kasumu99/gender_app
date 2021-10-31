import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_app/components/comment_stream.dart';
import 'package:gender_app/components/constants.dart';
import 'package:gender_app/model/user_preferences.dart';

class CasePageScreen extends StatelessWidget {
  final messageTextController = TextEditingController();
  String? messageText;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String reportCaseId;
  final String case_topic;
  final String case_description;
  final bool isAnonymous;
  final String fullName;
  final List<dynamic> fileUrl;

  CasePageScreen({
    required this.reportCaseId,
    required this.case_topic,
    required this.case_description,
    required this.fileUrl,
    required this.isAnonymous, required this.fullName
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Report Case',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Card(
                      margin: EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage('images/user_profile.jpg'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      isAnonymous ? Text('Anonymous',
                                        style: TextStyle(fontWeight: FontWeight.bold),):Text(fullName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                      Text(
                                        "Time Stamp",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Topic: ${case_topic}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Description of Report: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  case_description
                              ),
                            ),
                            fileUrl.isNotEmpty?Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Attachment: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ):Container(),
                            fileUrl.isNotEmpty ? IgnorePointer(
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                itemCount: fileUrl.length,
                                itemBuilder: (context, index) {
                                  return fileDesign(fileUrl);
                                },),
                            ) : Container(),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black12, width: 2.0),
                                )
                              ),
                              child: Text(
                                'Comment :',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                                height: 400,
                                child: CommentStream(reportCaseId: reportCaseId,)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
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
                  TextButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      messageTextController.clear();
                      _firestore.collection(reportCase_text).doc(reportCaseId).collection(Comment_text).add({
                        'text': messageText,
                        'sender': await UserPreferences.getFullname(),
                        'timeStamp': DateTime.now(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                  IconButton(
                      onPressed: () {

                      },
                      icon: Icon(FontAwesomeIcons.thumbsUp))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fileDesign(List<dynamic> fileUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Text(
                '.mp3',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white
                ),
              ),
            )
        ),
        const SizedBox(height: 8),
        Text(
          "sile.mp3",
          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
        ),
        Text(
          "10.9 MB",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
