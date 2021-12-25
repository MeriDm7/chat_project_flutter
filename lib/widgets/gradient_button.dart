import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String name;
  final Function onPressed;
  static const neored = Color(0xFFff0217);
  static const neopink = Color(0xFFf41c74);
  static const neopuprle = Color(0xFFff32ff);
  static const darkpurple = Color(0xFF400085);

  const GradientButton({
    required this.name,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[neored, darkpurple, neopuprle])),
      child: TextButton(
        onPressed: () => onPressed(),
        child: Text(
          name,
          style: const TextStyle(
              fontSize: 25, fontFamily: 'it', color: Colors.white),
        ),
      ),
    );
  }
}
