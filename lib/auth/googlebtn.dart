import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';

class GoogleBTN extends StatelessWidget {
  const GoogleBTN({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),color: Colors.blue,child: InkWell(onTap: (){},child: Row(mainAxisAlignment: MainAxisAlignment.start,children: [Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.white,),child: Image.asset("assets/google.png",width: 40,),),SizedBox(width: 8,),Textwidget(text: "Sign in with Google",color: Colors.white,textSize: 18,)],),),);
  }
}
