import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  final String btntext;
  final screen;
  final onpressed;
  const Btn({
    super.key,
    required this.onpressed,
    required this.btntext,
    this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blueAccent.withOpacity(0.7)),
      child: TextButton(
        onPressed: onpressed,
          // onPressed: () {
          //   FocusScope.of(context).unfocus();
          //   Navigator.push(context, screen);
          // },
          child: Text(btntext,
              style: const TextStyle(
                  color: Colors.white, letterSpacing: 3, fontSize: 16))),
    );
  }
}