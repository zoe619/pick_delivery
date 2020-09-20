import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_delivery/screen/T1Signup.dart';
import 'package:pick_delivery/screen/t1_walk/IntroScreen.dart';
import 'package:pick_delivery/screen/t1_walk/Walkthrough.dart';
import 'package:pick_delivery/utils/T1Images.dart';

class T1WalkThrough extends StatelessWidget {
  static var tag = "/T1WalkThrough";

  final List<Walkthrough> list = [
    Walkthrough(title: "Add Files", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ", imageIcon: t1_walk1),
    Walkthrough(title: "Select Files", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ", imageIcon: t1_walk2),
    Walkthrough(title: "Share Files", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ", imageIcon: t1_walk3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: IntroScreen(
          list,
          MaterialPageRoute(builder: (context) => T1Signup()),
        ),
      ),
    );
  }
}
