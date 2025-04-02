import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../innerscreen/ProductPage.dart';
import '../../theme/darkthemeprovider.dart';
import '../../widget/textwidget.dart';

class Recentviewwidget extends StatefulWidget {
  const Recentviewwidget({super.key});

  @override
  State<Recentviewwidget> createState() => _RecentviewwidgetState();
}

class _RecentviewwidgetState extends State<Recentviewwidget> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;
    return GestureDetector(onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductScreen()));

    },child: Container( height: MediaQuery.sizeOf(context).height * 0.12,decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Theme.of(context).cardColor),child: Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 8),
          width: MediaQuery.sizeOf(context).width * 0.2,
          height: MediaQuery.sizeOf(context).width * 0.25,
          child: FancyShimmerImage(
            imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
            boxFit: BoxFit.fill,
          ),
        ),SizedBox(width: 10,)
        ,Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Row(
          children: [
            Textwidget(text: "Title", color:textColor , textSize: 20,isTitle: true,),
            SizedBox(width: 10,),],
        ),SizedBox(width: 12,),Textwidget(text: "Price:\$2.1", color: textColor, textSize: 17)],),Spacer(),Padding(
          padding: const EdgeInsets.all(13.0),
          child: Icon(CupertinoIcons.plus_app_fill,color: Colors.green,size: 40,),
        )],
    ),),);
  }
}
