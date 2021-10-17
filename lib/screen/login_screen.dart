import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/components/form_textfield.dart';
import 'package:gender_app/components/rounded_button.dart';
import 'package:gender_app/helpers/common_functions.dart';
import 'package:gender_app/model/user_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isObscure = true;
  String? matricNo;
  String? email;
  String? password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference _students = _firestore.collection('students');
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 40,

                    ),
                  ),
                ),
                SizedBox(height: 20,),
                FormTextField(
                  inputType: TextInputType.text, labelText: 'Matric Number',
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
                  inputType: TextInputType.text, labelText: 'Password',
                  obsecureText: _isObscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
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
                RoundedButton(
                    title: 'Login',
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        var newMatricNo = matricNo!.toUpperCase().replaceAllMapped(RegExp(r'\/'), (match) {return '-';});
                        _students.doc(newMatricNo)
                            .get()
                            .then((DocumentSnapshot documentSnapshot) async {
                          if (documentSnapshot.exists) {
                            print('Document data: ${documentSnapshot.data()}');
                            email = documentSnapshot["email"];
                            try {
                              final newUser = await _auth.signInWithEmailAndPassword(
                                  email: email!,
                                  password: password!
                              );
                              if (newUser != null){
                                setState(() {
                                  _isLoading = false;
                                });
                                UserPreferences.setUserMatricNumber(newMatricNo);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (context) => HomePage(),
                                  ),
                                      (route) => false,
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                            }
                          }
                          else {
                            setState(() {
                              _isLoading = false;
                            });
                            print('Matric Number does not exist.');
                          }
                        });
                      }
                    },
                    width: 300
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
