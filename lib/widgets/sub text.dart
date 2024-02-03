import 'package:flutter/material.dart';

class SubText extends StatelessWidget {
  const SubText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[300],
      ),
    );
  }
}
