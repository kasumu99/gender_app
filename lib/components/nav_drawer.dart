import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/model/user_preferences.dart';
import 'package:gender_app/screen/report_case_screen.dart';
import 'package:gender_app/screen/welcome_screen.dart';

import 'rounded_button.dart';

class NavDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String image;
  FirebaseAuth _auth = FirebaseAuth.instance;
  NavDrawer({required this.userName, required this.userEmail, required this.image});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            padding: EdgeInsets.all(0),
            child: UserAccountsDrawerHeader(
              accountName: Text('Elias'),
              accountEmail: Text('kasumu.elias@gmail.com'),
              currentAccountPicture: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('images/user_profile.jpg'),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.send_outlined,
              color: Colors.black,
            ),
            title: const Text('Report a Case'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReportCaseScreen(),));
            },
          ),
          ListTile(
            leading: Icon(Icons.track_changes_outlined, color: Colors.black),
            title: const Text('Report Status'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),

          ListTile(
            leading:
                Icon(Icons.contact_support_outlined, color: Colors.black),
            title: const Text('Contact Us'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          RoundedButton(
              title: 'Logout',
              onPress: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                  title: Text('Are sure u want to Logout'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () async {
                        try{
                          await _auth.signOut().then((value) async {
                            await UserPreferences.removeAll();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen(),));
                          });
                        }catch(e){
                          print("Error: ${e}");
                        }
                      },
                      child: Text('yes'),
                    )
                  ],

                )
                );
              },
              width: double.infinity
          )
        ],
      ),
    );
  }
}
