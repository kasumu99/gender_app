import 'package:flutter/material.dart';
import 'package:gender_app/components/form_textfield.dart';
import 'package:gender_app/components/rounded_button.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
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
                inputType: TextInputType.emailAddress, labelText: 'EmailAddress',
              ),
              FormTextField(
                inputType: TextInputType.text, labelText: 'Password',
              ),
              RoundedButton(
                  title: 'Login',
                  onPress: () {

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
