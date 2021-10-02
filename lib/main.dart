import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/screen/home_page.dart';
import 'package:gender_app/screen/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        primaryColorDark: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,

        )
      ),
      home: WelcomeScreen(),
    );
  }
}
class InitializerWidget extends StatefulWidget {
  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  late FirebaseAuth _auth;
  late User? _user;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    isLoading = false;
  }
  @override
  Widget build(BuildContext context) {
    return isLoading ? Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ): _user == null ? WelcomeScreen() : HomePage();
  }
}
