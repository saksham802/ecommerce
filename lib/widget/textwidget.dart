import 'package:flutter/material.dart';

class Textwidget extends StatelessWidget {
  const Textwidget({
    super.key,
    required this.text,
    required this.color,
    required this.textSize,
    this.isTitle = false,
    this.maxline = 10,
  });

  final String text;
  final bool isTitle;
  final Color color;
  final double textSize;
  final int maxline;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxline,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        color: color,
        fontSize: textSize,
        fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}