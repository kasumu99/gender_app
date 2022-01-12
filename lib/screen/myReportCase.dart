import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_app/components/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'case_page_screen.dart';

class MyReportCase extends StatefulWidget {
  @override
  State<MyReportCase> createState() => _MyReportCaseState();
}

class _MyReportCaseState extends State<MyReportCase> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _mat;

  Future<void> _refresh() {
    return Future.delayed(
        Duration(seconds: 5)
    );
  }

  @override
  void initState() {
    super.initState();
    _matricNumber();
  }

  void _matricNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(()  {
      _mat = prefs.getString('matricNumber');
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'An Empty Page',
            style: TextStyle(
              fontSize: 23
            ),
          ),
        ),
      ),
    );
  }
}
