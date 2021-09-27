import 'package:flutter/material.dart';
import 'package:gender_app/components/form_textfield.dart';
import 'package:gender_app/components/rounded_button.dart';

import 'home_page.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  String? matricNo;
  String? password;
  @override
  Widget build(BuildContext context) {
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
                inputType: TextInputType.emailAddress, labelText: 'Matric Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
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
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (context) => HomePage(),
                        ),
                            (route) => false,
                      );
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
