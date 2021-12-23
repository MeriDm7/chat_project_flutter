import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  static const neored = const Color(0xFFff0217);
  static const neopink = const Color(0xFFf41c74);
  static const neopuprle = const Color(0xFFff32ff);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[neored, neopink, neopuprle])),
        child: null /* add child content here */,
      ),
    );
  }
}
