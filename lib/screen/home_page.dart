import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/components/rounded_button.dart';
import 'package:gender_app/screen/welcome_screen.dart';

class HomePage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("App name Here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
              ),
            )
          ];
        },
        body: Center(
        child: RoundedButton(
          width: 30,
          onPress: () {
            _auth.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<dynamic>(
                builder: (context) => WelcomeScreen(),
              ),
                  (route) => false,
            );
          },
          title: 'Log out',

        ),
        ),
      ),
    );
  }
}
