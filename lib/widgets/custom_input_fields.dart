import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;
  final String validationText;

  CustomTextFormField(
      {required this.onSaved,
      required this.regEx,
      required this.hintText,
      required this.obscureText,
      required this.validationText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (_value) => onSaved(_value!),
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: (_value) {
        return RegExp(regEx).hasMatch(_value!) ? null : validationText;
      },
      decoration: InputDecoration(
        fillColor: Colors.white24,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle:
            TextStyle(fontSize: 18, fontFamily: 'th', color: Colors.white70),
      ),
    );
  }
}

class ChatTextFromField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;

  const ChatTextFromField(
      {Key? key,
      required this.onSaved,
      required this.regEx,
      required this.hintText,
      required this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (_value) => onSaved(_value!),
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: (_value) {
        return RegExp(regEx).hasMatch(_value!) ? null : 'Enter a valid value';
      },
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  IconData? icon;

  CustomTextField(
      {required this.onEditingComplete,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: () => onEditingComplete(controller.value.text),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Colors.white24,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            fontSize: 18, fontFamily: 'th', color: Colors.white70),
      ),
    );
  }
}
