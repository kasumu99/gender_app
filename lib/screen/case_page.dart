import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gender_app/components/comment_stream.dart';
import 'package:gender_app/components/constants.dart';
import 'package:gender_app/model/user_preferences.dart';

class CasePage extends StatelessWidget {
  final messageTextController = TextEditingController();
  String? messageText;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String reportCaseId;
  final String case_topic;
  final String case_description;
  final List<dynamic> fileUrl;

  CasePage({required this.reportCaseId, required this.case_topic, required this.case_description, required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    print("file: ${fileUrl}");
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
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'Topic: ${case_topic}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
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
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            case_description
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Attachment: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    IgnorePointer(
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
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Comment',
                        style: TextStyle(
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Container(
                      height: 400,
                        child: CommentStream(reportCaseId: reportCaseId,)),
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
