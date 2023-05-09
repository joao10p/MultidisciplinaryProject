import 'package:flutter/material.dart';

class SlideUpWidget extends StatefulWidget {
 // final SlideUpController controller;


  @override
  _SlideUpWidgetState createState() => _SlideUpWidgetState();
}

class _SlideUpWidgetState extends State<SlideUpWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20))),
    );
  }
}