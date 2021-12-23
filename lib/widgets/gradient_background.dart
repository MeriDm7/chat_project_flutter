import 'package:flutter/material.dart';
import 'package:chat/widgets/custom_colors.dart';

class BaseLayout extends StatelessWidget {
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
