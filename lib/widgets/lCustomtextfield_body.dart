import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hinttext,
      required this.labeltext,
      required this.controller,
      required this.validator});
  final String hinttext, labeltext;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          hintText: hinttext,
          labelText: labeltext,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );
  }
}
