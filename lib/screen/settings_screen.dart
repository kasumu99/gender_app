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

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin{
  bool isVisible = false;
  AnimationController? _controller;
  Animation<Offset>? _animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =  AnimationController(
      vsync: this,
      duration: Duration(seconds: 1)
    );
    _animation = Tween<Offset>(begin: Offset(0.0, -0.03), end: Offset.zero)
        .animate(_controller!);

  }

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
                title: Text("Elias",style: TextStyle(color: Colors.white),),
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
              child: Column(
                children: [
                  ListTile(
                    title: Text('Change Password'),
                    leading: Icon(Icons.lock_outline,color: Colors.black),
                    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black),
                    onTap: () {
                      if(isVisible == false){
                        setState(() {
                          isVisible = !isVisible;
                        });
                        _controller!.forward();
                      }
                      else{
                        _controller!.reverse().whenComplete((){
                          setState(() {
                            isVisible = !isVisible;
                          });
                        });
                      }

                    },
                  )
                ],
              ),
            ),
            Visibility(
              visible: isVisible,
              child: SlideTransition(
                position: _animation!,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 32.0),
                  elevation: 1,
                  child: Column(
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
                            setState(() {
                              isVisible = false;
                            });
                          },
                        width: 30,
                          title: 'Save',
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
