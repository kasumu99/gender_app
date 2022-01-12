import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/components/form_textfield.dart';
import 'package:gender_app/components/rounded_button.dart';
import 'package:gender_app/screen/user_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Settings',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
              color: Colors.black,
              elevation: 8.0,
              child: ListTile(
                title: Text("My Profile",style: TextStyle(color: Colors.white),),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('images/user_profile.jpg'),
                ),
                trailing: Icon(Icons.edit,color: Colors.white,),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(),));
                },
              ),
            ),
            const SizedBox(height: 10.0,),
            Card(
                shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
                elevation: 4.0,
              child: ExpansionTile(
                title: Text('Change Password'),
                leading: Icon(Icons.lock_outline),
                children: [
                  FormTextField(
                    labelText: 'Current Password',
                    inputType: TextInputType.visiblePassword,
                    obsecureText: true,
                  ),
                  FormTextField(
                    labelText: 'New Password',
                    inputType: TextInputType.visiblePassword,
                    obsecureText: true,
                  ),
                  FormTextField(
                    labelText: 'Confirm new  Password',
                    inputType: TextInputType.visiblePassword,
                    obsecureText: true,
                  ),
                  RoundedButton(
                    onPress: () {

                    },
                    width: 30,
                    title: 'Save',
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
