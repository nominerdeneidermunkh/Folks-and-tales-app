import 'package:flutter/material.dart';
import 'package:folks/utils/folks_color.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          fillColor: const Color(0xFF313E55).withOpacity(0.78),
          filled: true,
          isDense: true,
          labelText: hintText,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.48),
            fontSize: 13,
          ),
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.48),
            fontSize: 13,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
