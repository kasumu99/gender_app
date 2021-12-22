import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentBubble extends StatelessWidget {
  final String sender;
  final String text;
  CommentBubble({required this.sender, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('images/user_profile.jpg'),
            backgroundColor: Colors.white,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight:FontWeight.w700,
                        color: Colors.black54
                    ),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight:FontWeight.w400,
                        color: Colors.black54
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}