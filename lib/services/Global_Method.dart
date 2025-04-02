import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Future<void> warningDialog({
required String title,
required String subtitle,
required Function fct,
required BuildContext context,
}) async {
await showDialog(
context: context,
builder: (context) {
return AlertDialog(
title: Row(children: [
  Image.asset(
    'assets/warningsign.png',
    height: 50,
    width: 50,
    fit: BoxFit.fill,
  ),
const SizedBox(
width: 8,
),
Flexible(flex:1,child: Text(title)),
]),
content: Text(subtitle),
actions: [
TextButton(
onPressed: () {
if (Navigator.canPop(context)) {
Navigator.pop(context);
}
},
child: Textwidget(
color: Colors.cyan,
text: 'Cancel',
textSize: 18,
),
),
TextButton(
onPressed: () {
fct();
},
child: Textwidget(
color: Colors.red,
text: 'OK',
textSize: 18,
),
),
],
);
});
}

