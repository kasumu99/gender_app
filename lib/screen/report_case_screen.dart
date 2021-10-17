import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gender_app/components/rounded_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gender_app/model/user_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ReportCaseScreen extends StatefulWidget {
  @override
  State<ReportCaseScreen> createState() => _ReportCaseScreenState();
}

class _ReportCaseScreenState extends State<ReportCaseScreen> {
  List<File>? files;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isAnonymously = true;
  String? caseTitle;
  String? caseDescription;

  @override
  Widget build(BuildContext context) {
    CollectionReference _students = _firestore.collection('students');
    CollectionReference _reportcase = _firestore.collection('report_case');
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
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Form(
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
                  onChanged: (value) => caseTitle = value,
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
                  onChanged: (value) => caseDescription = value,
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
                  padding: EdgeInsets.all(10),
                  child: files != null ? Column(
                    children: [
                      IconButton(
                        alignment: Alignment.topRight,
                          onPressed: () {

                          },
                          icon: Icon(Icons.close)),
                      Text(
                        'file name'
                      )
                    ],

                  ): Text('No Attachment',style: TextStyle(fontSize: 20),),
                ),
                RoundedButton(
                    title: 'Pick A file',
                    onPress: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
                      if (result != null) {
                        files = result.paths.map((path) => File(path!)).toList();
                        print(files!.length);
                        PlatformFile file = result.files.first;
                        print(file.path);

                      } else {
                        // User canceled the picker
                      }
                    },
                    width: 40),
                Row(
                  children: [
                    Checkbox(
                      value: _isAnonymously,
                      onChanged: (value) {
                        setState(() {
                          _isAnonymously = value!;
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
                        setState(() {
                          _isLoading = true;
                        });
                        if(_isAnonymously){
                          _reportcase
                          .add({
                            'case_title' : caseTitle,
                            'case_description' : caseDescription,
                            'anonymously': true,
                          })
                          .then((value){
                            setState(() {
                              _isLoading = false;
                            });
                            print('Sucessfull');
                          });
                        }else{
                          _reportcase
                              .add({
                            'case_title' : caseTitle,
                            'case_description' : caseDescription,
                            'anonymously': false,
                            'victim_name': await UserPreferences.getUserMatricNumber(),
                          }).then((value){
                            setState(() {
                              _isLoading = false;
                            });
                            print('Sucessfull');
                          });
                        }
                      }
                    },
                    width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
