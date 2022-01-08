import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/components/constants.dart';
import 'package:gender_app/components/form_textfield.dart';
import 'package:gender_app/components/rounded_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? _matric;
  String? email;
  File? _image;
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;
  firebase_storage.Reference? _ref;
  String ImageUrl = "images/user_profile.jpg";

  @override
  void initState() {
    super.initState();
    _matricNumber();
    checkForImageValidity();
  }
  void _matricNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(()  {
      _matric = prefs.getString('matricNumber');
    });
  }
  bool checkForImageValidity(){
    _firestore.collection(students_txt)
        .doc(_matric)
        .get()
        .then((value){
          if (value.exists){
            if(value.data()!.containsKey('UserImage')){
              setState(() {
                ImageUrl = value['UserImage'];
                print("images = ${ImageUrl}");
              });
              return true;
            }else{
              ImageUrl = 'images/user_profile.jpg';
              print("image = ${ImageUrl}");
              return false;
            }
          }
        });
    return true;
  }
  @override
  Widget build(BuildContext context) {
    print(_matric);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'User Profile',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
        body: SafeArea(
          child: Column(
            children: [
              !_isLoading ? Container(
                padding: EdgeInsets.all(20),
                child: GestureDetector(
                  child: Stack(
                    children: [
                      checkForImageValidity() ? CachedNetworkImage(
                        imageUrl: ImageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ):
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('images/user_profile.jpg'),
                        backgroundColor: Colors.white,
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(Icons.edit,color: Colors.white,size: 15,),
                        ),
                      )
                    ],
                  ),
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.image);
                    if (result != null) {
                      _image = File(result.files.single.path!);
                      setState(() {
                        _isLoading = true;
                      });
                      _ref = _storage.ref('UserImage/${Path.basename(_image!.path)}');
                      await _ref!.putFile(_image!).whenComplete(() async {
                        await _ref!.getDownloadURL().then((values){
                          _storage.refFromURL(ImageUrl).delete()
                              .then((value){
                            _firestore.collection(students_txt)
                                .doc(_matric).update({'UserImage': values})
                                .then((value){
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          });
                        });
                      });
                    }
                  },
                ),
              ) : CircularProgressIndicator(),
              Expanded(
                child: ListView(
                  children: [
                    FormTextField(
                      inputType: TextInputType.name,
                      labelText: 'First Name',
                      isEnabled: false,
                      initialText: "First",
                    ),
                    FormTextField(
                      inputType: TextInputType.name,
                      labelText: 'Surname',
                      isEnabled: false,
                    ),
                    FormTextField(
                      inputType: TextInputType.text,
                      labelText: 'Matric Number',
                      initialText: _matric,
                    ),
                    FormTextField(
                      inputType: TextInputType.emailAddress,
                      labelText: 'Email Address',
                      isEnabled: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topLeft: Radius.circular(10)),
                              ),
                              width: 60,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '+234',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              height: 56,
                            ),
                          ),
                          Flexible(
                              child: FormTextField(
                                inputType: TextInputType.number, labelText: 'Phone Number',
                                maxLength: 11,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }else if(value.length < 11){
                                    return 'Enter Complete Number';
                                  }
                                  return null;
                                },
                              )
                          )
                        ],
                      ),
                    ),
                    RoundedButton(
                      title: 'Save',
                      width: double.infinity,
                      onPress: () {

                      },
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
  buildShowDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

