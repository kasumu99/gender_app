import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/components/nav_drawer.dart';
import 'package:gender_app/model/user_preferences.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'App Name Here',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      drawer: NavDrawer(
        image: '',
        userEmail: '',
        userName: '',
      ),
      body: SafeArea(
        child: ListView(
          children: [

          ],
        ),
      ),
    );
  }
}