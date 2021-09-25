import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gender_app/components/form_textfield.dart';
import 'package:gender_app/components/rounded_button.dart';

class RegisterScreen extends StatefulWidget {

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    bool _isObscure = true;
    return Scaffold(
      body: SafeArea(
        child: Form(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 40,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  children: [
                    FormTextField(
                      inputType: TextInputType.name, labelText: 'UserName',
                    ),
                    FormTextField(
                      inputType: TextInputType.text, labelText: 'Matrix Number',
                    ),
                    FormTextField(
                      inputType: TextInputType.emailAddress, labelText: 'Email Address',
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
                            inputType: TextInputType.number, labelText: 'Phone Number',maxLength: 11,
                          )
                          )
                        ],
                      ),
                    ),
                    FormTextField(
                      inputType: TextInputType.text,
                      labelText: 'Password',
                      obsecureText: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    FormTextField(
                      inputType: TextInputType.text,
                      labelText: 'Re-enter-Password',
                      obsecureText: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _isObscure ? Icons.visibility : Icons.visibility_off ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    RoundedButton(
                        title: 'Register',
                        onPress: () {

                        },
                        width: 300
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
