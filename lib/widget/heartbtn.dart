import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class Heartbtn extends StatelessWidget {
  const Heartbtn({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Heart Clicked");
      },
      child: Icon(IconlyLight.heart, size: 24),
    );
  }
}
