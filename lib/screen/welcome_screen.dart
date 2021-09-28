import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gender_app/components/rounded_button.dart';
import 'package:gender_app/screen/login_screen.dart';
import 'package:gender_app/screen/register_screen.dart';
import 'package:gender_app/util/welcome_item.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double currentPage = 0.0;
  @override
  Widget build(BuildContext context) {
    final _pageViewController = new PageController();
    List<Widget> slides = welcomeItem
    .map((item) => Container(
      child: Image.asset(
        item['image'],
        fit: BoxFit.fill,
      ),
    )).toList();
    List<Widget> indicator() => List<Widget>.generate(
        slides.length,
            (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 3.0),
          height: currentPage.round() == index ? 20.0 : 10,
          width: currentPage.round() == index ? 20.0 : 10,
          decoration: BoxDecoration(
              color: currentPage.round() == index
                  ? Colors.red
                  : Colors.white,
              borderRadius: BorderRadius.circular(30.0)),
        ));
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageViewController,
                itemCount: slides.length,
                itemBuilder: (BuildContext context, int index) {
                  _pageViewController.addListener(() {
                    setState(() {
                      currentPage = _pageViewController.page!;
                    });
                  });
                  return slides[index];
                },
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicator(),
                  ),
                )
            ),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    RoundedButton(
                      title: 'Register',
                      width: 300,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ));
                      },
                    ),
                    Container(
                      width: 300,
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                            ),
                          ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
