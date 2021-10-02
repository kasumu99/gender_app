import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("App name Here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
              ),
            )
          ];
        },
        body: Center(
        child: Text("Sample text"),
        ),
      ),
    );
  }
}
