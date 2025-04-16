import 'package:ecommerce/innerscreen/ProductPage.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/darkthemeprovider.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;


    return GestureDetector(onTap: (){


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
        SizedBox(width: 10,),Textwidget(text: "X12", color: textColor, textSize: 20,isTitle: true,)],
      ),SizedBox(width: 12,),Textwidget(text: "Paid :\$2.1", color: textColor, textSize: 17)],),Spacer(),Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("02/04/2025",style: TextStyle(fontSize: 17,color: textColor),),
      )],
    ),),);
  }
}
