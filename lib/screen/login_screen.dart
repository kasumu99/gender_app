import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/components/form_textfield.dart';
import 'package:gender_app/components/rounded_button.dart';
import 'package:gender_app/helpers/common_functions.dart';

import 'home_page.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isObscure = true;
  String? matricNo;
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    CollectionReference _students = firestore.collection('students');
    getEmailAddress(String matric){
      var newMatricNo = matric.replaceAllMapped(RegExp(r'\/'), (match) {return '-';});
      _students.doc(newMatricNo)
      .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('Document data: ${documentSnapshot.data()}');
        } else {
          print('Document does not exist on the database');
        }
      });
    };
    return Scaffold(
      body: SafeArea(
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
                      try {
                        final newUser = await _auth.signInWithEmailAndPassword(
                            email: email!,
                            password: password!
                        );
                        if (newUser != null){
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (context) => HomePage(),
                            ),
                                (route) => false,
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }
                    }
                  },
                  width: 300
              ),

            ],
          ),
        ),
      ),
    );
  }
}
