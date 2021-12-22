import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/components/constants.dart';
import 'package:gender_app/components/form_textfield.dart';
import 'package:gender_app/components/overlay_progress_bar.dart';
import 'package:gender_app/components/rounded_button.dart';
import 'package:gender_app/helpers/common_functions.dart';
import 'package:gender_app/model/user_preferences.dart';

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(animatedTexts: [
                TypewriterAnimatedText(
                  'Login',
                  textStyle:
                  TextStyle(fontSize: 40, fontStyle: FontStyle.italic),
                )
              ]),
              SizedBox(
                height: 20,
              ),
              FormTextField(
                inputType: TextInputType.text,
                labelText: 'Matric Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!confirmMatricNumber(value)) {
                    return 'Invalid matric number';
                  }
                  return null;
                },
                onChanged: (value) => matricNo = value,
              ),
              FormTextField(
                inputType: TextInputType.text,
                labelText: 'Password',
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
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      showSendingProgressBar();
                      var newMatricNo = matricNo!
                          .toUpperCase()
                          .replaceAllMapped(RegExp(r'\/'), (match) {
                        return '-';
                      });
                      _students
                          .doc(newMatricNo)
                          .get()
                          .then((DocumentSnapshot documentSnapshot) async {
                        if (documentSnapshot.exists) {
                          print('Document data: ${documentSnapshot.data()}');
                          email = documentSnapshot["email"];
                          UserPreferences.setFullname(
                              "${documentSnapshot["FirstName"]} ${documentSnapshot["SurName"]}");
                          try {
                            final newUser =
                            await _auth.signInWithEmailAndPassword(
                                email: email!, password: password!);
                            if (newUser != null) {
                              setState(() {
                                hideSendingProgressBar();
                              });
                              UserPreferences.setUserMatricNumber(
                                  newMatricNo);
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
                              hideSendingProgressBar();
                            });
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    'No user found for that email.'),
                              ));
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                const Text('Wrong password provided'),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text('Retry'),
                              ));
                            }
                          }
                        } else {
                          setState(() {
                            hideSendingProgressBar();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Invalid Matric Number'),
                          ));
                        }
                      }).catchError((error) {
                        setState(() {
                          hideSendingProgressBar();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                          const Text('Check Your Internet Connectivity'),
                        ));
                      });
                    }
                  },
                  width: 300),
            ],
          ),
        ),
      ),
    );
  }
}
