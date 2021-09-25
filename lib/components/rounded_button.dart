import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final double width;
  final Function() onPress;
  RoundedButton({required this.title,required this.onPress, required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
      child: Material(
        elevation: 5.0,
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: width,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}