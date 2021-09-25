import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/components/rounded_button.dart';
import 'package:gender_app/screen/login_screen.dart';
import 'package:gender_app/screen/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: PageView(

            ),
          ),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RoundedButton(
                    title: 'Register',
                    width: 300,
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ));
                    },
                  ),
                  Container(
                    width: 300,
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                          ),
                        ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
