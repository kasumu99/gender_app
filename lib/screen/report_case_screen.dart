import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gender_app/components/overlay_progress_bar.dart';
import 'package:gender_app/components/rounded_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gender_app/model/user_preferences.dart';
import 'package:gender_app/model/user_report_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';


class ReportCaseScreen extends StatefulWidget {
  @override
  State<ReportCaseScreen> createState() => _ReportCaseScreenState();
}

class _ReportCaseScreenState extends State<ReportCaseScreen> {
  List<File> file_paths = [];
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;
  firebase_storage.Reference? _ref;
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  final UserReportModel _userReportModel = new UserReportModel();
  OverlayProgressBar? _sendingMsgProgressBar;
  String? _mat;

  @override
  void initState() {
    super.initState();
    _sendingMsgProgressBar = OverlayProgressBar();
    _getSharedPref();
  }
  void _getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(()  {
      _mat = prefs.getString('matricNumber');
    });
  }

  @override
  void dispose() {
    _sendingMsgProgressBar!.hide();
    super.dispose();
  }

  void showSendingProgressBar() {
    _sendingMsgProgressBar!.show(context);
  }

  void hideSendingProgressBar() {
    _sendingMsgProgressBar!.hide();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference _reportcase = _firestore.collection('report_case');
    CollectionReference _student = _firestore.collection('students');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Report Case',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Case Title',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              TextFormField(
                  autofocus: true,
                  controller: _controller,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white),
                onChanged: (value) => _userReportModel.reportName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your title';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Case Description',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              TextFormField(
                autofocus: true,
                controller: _controller2,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white),
                onChanged: (value) => _userReportModel.reportDescription = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter case description';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Upload Evidence',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                color: Colors.white,
                height: 50,
                padding: EdgeInsets.all(10),
                child: file_paths.isNotEmpty ? ListView.builder(
                  itemCount: file_paths.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Text("${Path.basename(file_paths[index].path)}"),
                          IconButton(
                            icon: Icon(Icons.close_rounded),
                            onPressed: () {
                              setState(() {
                                file_paths.removeAt(index);
                              });
                            },
                            padding: EdgeInsets.all(0),
                          ),
                        ],
                      ),
                    );
                },
                ): Text('No Attachment',style: TextStyle(fontSize: 20),),
              ),
              RoundedButton(
                  title: 'Pick A file',
                  onPress: () async {
                    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
                    if(result != null){
                      List<File> path = result.paths.map((path) => File(path!)).toList();
                      for (var n in path){
                        print("path ${path}");

                        setState(() {
                          file_paths.add(n);
                        });
                        // final f = File('whateveripicked.mp4');
                        // int sizeInBytes = f.lengthSync();
                        // double sizeInMb = sizeInBytes / (1024 * 1024);
                        // if (sizeInMb > 10){
                        //   // This file is Longer the
                        // }
                      }
                    }
                  },
                  width: 40),
              Row(
                children: [
                  Checkbox(
                    value: _userReportModel.isAnonymously,
                    onChanged: (value) {
                      setState(() {
                        _userReportModel.isAnonymously = value!;
                      });
                    },
                  ),
                  Text(
                    'Submit Anonymously'
                  )
                ],
              ),
              RoundedButton(
                  title: 'Submit',
                  onPress: () async {
                    if (_formKey.currentState!.validate()){
                      showSendingProgressBar();
                      List thumpsUp = [];
                      List myReportCase = [];
                      uploadFile().whenComplete(() async {
                        if(_userReportModel.isAnonymously){
                          _reportcase
                              .add({
                            'case_title' : _userReportModel.reportName,
                            'case_description' : _userReportModel.reportDescription,
                            'anonymously': true,
                            'evidence_attachment': _userReportModel.imageUrl,
                            'caseTimeStamp': DateTime.now(),
                            'thumbUps' : thumpsUp,
                          }).then((value){
                            myReportCase.add(value.id);
                            _student.doc(_mat)
                            .update({'myreportId': FieldValue.arrayUnion(myReportCase)})
                            .then((value){
                              setState(() {
                                hideSendingProgressBar();
                                _controller.clear();
                              });
                              Navigator.pop(context);
                            });
                          }).catchError((error){
                            setState(() {
                              hideSendingProgressBar();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Check Your Internet Connectivity'),));
                          });
                        }
                        else{
                          _reportcase
                              .add({
                            'case_title' : _userReportModel.reportName,
                            'case_description' : _userReportModel.reportDescription,
                            'anonymously': false,
                            'victim_name': await UserPreferences.getFullname(),
                            'evidence_attachment': _userReportModel.imageUrl,
                            'caseTimeStamp': DateTime.now(),
                            'thumbUps' : thumpsUp,
                          }).then((value){
                            myReportCase.add(value.id);
                            _student.doc(_mat)
                                .update({'myreportId': FieldValue.arrayUnion(myReportCase)})
                                .then((value){
                              setState(() {
                                hideSendingProgressBar();
                                _controller.clear();
                              });
                              Navigator.pop(context);
                            });
                          }).catchError((error){
                            setState(() {
                              hideSendingProgressBar();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Check Your Internet Connectivity'),));
                          });
                        }
                      });
                    }
                  },
                  width: 10),
            ],
          ),
        ),
      ),
    );
  }
  Future uploadFile() async{
    for(var file in file_paths){
      _ref = _storage
      .ref('evidence_attachment/${Path.basename(file.path)}');
      await _ref!.putFile(file).whenComplete(() async {
        await _ref!.getDownloadURL().then((value){
          _userReportModel.imageUrl.add(value);
        });
      });
    }
  }
}

