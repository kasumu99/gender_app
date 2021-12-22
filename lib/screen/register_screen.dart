import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gender_app/components/constants.dart';
import 'package:gender_app/components/form_textfield.dart';
import 'package:gender_app/components/overlay_progress_bar.dart';
import 'package:gender_app/components/rounded_button.dart';
import 'package:gender_app/helpers/common_functions.dart';
import 'package:gender_app/model/user_preferences.dart';
import 'package:gender_app/screen/home_page.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? firstName;
  String? matricNo;
  String? newMatricNo;
  String? lastName;
  String? email;
  String? phoneNo;
  String? password;
  String? confirm_password;
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  OverlayProgressBar? _sendingMsgProgressBar;

  @override
  void initState() {
    super.initState();
    _sendingMsgProgressBar = OverlayProgressBar();
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
    CollectionReference _students = _firestore.collection(students_txt);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Register',
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(fontSize: 40, fontStyle: FontStyle.italic),)
                  ]
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  children: [
                    FormTextField(
                      inputType: TextInputType.name,
                      labelText: 'First Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) => firstName = value,
                    ),
                    FormTextField(
                      inputType: TextInputType.name,
                      labelText: 'Surname',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) => lastName = value,
                    ),
                    FormTextField(
                      inputType: TextInputType.text,
                      labelText: 'Matric Number',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }else if(!confirmMatricNumber(value)){
                          return 'Invalid matric number';
                        }
                        return null;
                      },
                      onChanged: (value) => matricNo = value,
                    ),
                    FormTextField(
                      inputType: TextInputType.emailAddress, labelText: 'Email Address',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) => email = value,
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
                                  return 'Remove the leading zero';
                                }
                                return null;
                              },
                              onChanged: (value) => phoneNo = value,
                          )
                          )
                        ],
                      ),
                    ),
                    FormTextField(
                      inputType: TextInputType.text,
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure1 ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure1 = !_isObscure1;
                          });
                        },
                      ),
                      obsecureText: _isObscure1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    FormTextField(
                      inputType: TextInputType.text,
                      labelText: 'Re-enter-Password',
                      obsecureText: _isObscure2,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _isObscure2 ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure2 = !_isObscure2;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        else if(password != value){
                          return 'Password does not match';
                        }
                        return null;
                      },
                      onChanged: (value) => confirm_password = value,
                    ),
                    RoundedButton(
                        title: 'Register',
                        onPress: () async {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            showSendingProgressBar();
                            newMatricNo = matricNo!.replaceAllMapped(RegExp(r'\/'), (match) {return '-';});
                            try {
                             await _auth
                                 .createUserWithEmailAndPassword(
                                 email: email!, password: password!)
                                 .then((value){
                               if (value != null){
                                 _students.doc(newMatricNo!.toUpperCase())
                                     .set({
                                   'email' : email,
                                   'matric' : matricNo!.toUpperCase(),
                                   'FirstName' : "${firstName}",
                                   'SurName' : "${lastName}",
                                   'phone' : phoneNo,
                                   'id': value.user!.uid
                                 },
                                 )
                                     .then((value){
                                   UserPreferences.setUserMatricNumber(newMatricNo!);
                                   UserPreferences.setFullname("${firstName} ${lastName}");
                                   Navigator.pushAndRemoveUntil(
                                       context,
                                       MaterialPageRoute<dynamic>(
                                         builder: (context) => HomePage(),
                                       ),
                                           (route) => false);
                                 })
                                     .catchError((error) => print("Failed to add user: $error"));
                               }
                                 });
                            } on FirebaseAuthException catch (e){
                              setState(() {
                                hideSendingProgressBar();
                              });
                                if(e.code == "network-request-failed"){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network error')));
                                }else if(e.code == "email-already-in-use"){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email already in use')));
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${e.code}')));
                                }
                            }
                          }
                        },
                        width: 300
                    )
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
