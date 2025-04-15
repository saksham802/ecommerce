import 'package:flutter/material.dart';
import '../widget/textwidget.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.fct,
    required this.buttonText,
    this.primary = Colors.white38,
  }) : super(key: key);

  final void Function()? fct;
  final String buttonText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
        ),
        onPressed: fct, // null-safe
        child: Textwidget(
          text: buttonText,
          textSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
