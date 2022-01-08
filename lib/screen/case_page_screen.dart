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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class CasePageScreen extends StatefulWidget {
  final String reportCaseId;
  final String case_topic;
  final String case_description;
  final bool isAnonymous;
  final String? fullName;
  final Timestamp timeStamp;
  bool isLiked;
  final List<dynamic> fileUrl;

  CasePageScreen({
    required this.reportCaseId,
    required this.case_topic,
    required this.case_description,
    required this.fileUrl,
    required this.isAnonymous,
    this.fullName,
    required this.isLiked,
    required this.timeStamp
  });

  @override
  State<CasePageScreen> createState() => _CasePageScreenState();
}

class _CasePageScreenState extends State<CasePageScreen> {
  final messageTextController = TextEditingController();
  String? _mat;
  String? messageText;
  @override
  void initState() {
    super.initState();
    _getSharedPref();
  }

  void _getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(()  {
      _mat = prefs.getString('matricNumber');
    });
  }
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                                  backgroundColor: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.fullName!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                      Text(
                                        timeago.format(widget.timeStamp.toDate()),
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
                                'Topic: ${widget.case_topic}',
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
                                widget.case_description,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300
                                ),
                              ),
                            ),
                            widget.fileUrl.isNotEmpty?Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Attachment: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ):Container(),
                            widget.fileUrl.isNotEmpty ?
                            GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 20,
                              ),
                              itemCount: widget.fileUrl.length,
                              padding: EdgeInsets.all(8),
                              itemBuilder: (context, index) {
                                return fileDesign(widget.fileUrl);
                              },) : Container(),
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
                                child: CommentStream(reportCaseId: widget.reportCaseId,)),
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
                      _firestore.collection(reportCase_text).doc(widget.reportCaseId).collection(Comment_text).add({
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
                      onPressed: () async {
                        setState((){
                          widget.isLiked = !widget.isLiked;
                        });
                        List<String?> matric = [];
                        matric.add(_mat);
                        widget.isLiked ?_firestore.collection(reportCase_text).doc(widget.reportCaseId)
                            .update({'thumbUps': FieldValue.arrayUnion(matric)}):
                        _firestore.collection(reportCase_text).doc(widget.reportCaseId)
                            .update({'thumbUps': FieldValue.arrayRemove(matric)});
                      },
                      icon: widget.isLiked ? Icon(FontAwesomeIcons.solidThumbsUp) : Icon(FontAwesomeIcons.thumbsUp)
                  )
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
            child: GestureDetector(
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
              ),
              onTap: () => print('click'),
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
