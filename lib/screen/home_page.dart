import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gender_app/components/constants.dart';
import 'package:gender_app/components/nav_drawer.dart';
import 'package:gender_app/screen/case_page.dart';

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
          stream: _firestore.collection(reportCase_text).snapshots(),
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
                  return GestureDetector(
                    child: Card(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Row (
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
                                SizedBox(width: 10,),
                                Icon(Icons.comment_outlined),
                                Text('8'),
                                Text(
                                  're-solve',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.green
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CasePage(
                              reportCaseId: snapshot.data!.docs[index].id,
                              case_description: snapshot.data!.docs[index].get('case_description'),
                              case_topic: snapshot.data!.docs[index].get('case_title'),),
                          ));
                    },
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