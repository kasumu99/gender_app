import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gender_app/components/nav_drawer.dart';

class HomePage extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
        child: StreamBuilder(
          stream: _firestore.collection('report_case').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
            return Container(
              height: double.infinity,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Report Topic: ${snapshot.data!.docs[index].get('case_title')}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.thumb_up_outlined ),
                              Text('12'),
                              Icon(Icons.comment_outlined),
                              Text('8'),
                              Text(
                                're-solve',
                                style: TextStyle(
                                    color: Colors.green
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          },

        ),
      ),
    );
  }
}