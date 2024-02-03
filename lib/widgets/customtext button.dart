import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.text2});
  final void Function() onPressed;
  final String text, text2;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            text2,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
