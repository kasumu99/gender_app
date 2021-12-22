import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_app/components/constants.dart';
import 'package:gender_app/components/nav_drawer.dart';
import 'package:gender_app/screen/case_page_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    List like = snapshot.data!.docs[index].get("thumbUps");
                    bool getIsLiked(){
                      for(var n in like){
                        if(_mat == n.toString()){
                          return true;
                        }
                      }
                      return false;
                    }
                    return GestureDetector(
                      child: Card(
                        margin: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row (
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage('images/user_profile.jpg'),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Report Topic: ${snapshot.data!.docs[index].get('case_title')}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.thumbsUp),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('${like.length-1}'),
                                  ),
                                  Expanded(
                                    child: Text(
                                      're-solve',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.green
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: (){
                        // bool getIsLiked(){
                        //   List like = snapshot.data!.docs[index].get("thumbUps");
                        //   for(var n in like){
                        //     if(_mat == n.toString()){
                        //       return true;
                        //     }
                        //   }
                        //   return false;
                        // }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CasePageScreen(
                                reportCaseId: snapshot.data!.docs[index].id,
                                case_description: snapshot.data!.docs[index].get('case_description'),
                                case_topic: snapshot.data!.docs[index].get('case_title'),
                                fileUrl: snapshot.data!.docs[index].get('evidence_attachment'),
                                isAnonymous: snapshot.data!.docs[index].get('anonymously'),
                                fullName: snapshot.data!.docs[index].get('victim_name'),
                                isLiked: getIsLiked(),
                              ),
                            ));
                      },
                    );
                  },
                ),
              ),
            );
          },

        ),
      ),
    );
  }
}