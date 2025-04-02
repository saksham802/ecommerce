import 'package:ecommerce/screens/Viewed/RecentViewWidget.dart';
import 'package:ecommerce/widget/EmptyScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../services/Global_Method.dart';
import '../../theme/darkthemeprovider.dart';

class Recentviewed extends StatefulWidget {
  const Recentviewed({super.key});

  @override
  State<Recentviewed> createState() => _RecentviewedState();
}

class _RecentviewedState extends State<Recentviewed> {
  bool isWishListEmpty=true;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;

    return isWishListEmpty ? Emptyscreen(imagePath: 'assets/wishlist.png', title:"Your WishList is Empty", subtitle: "Add Something that you wish", buttonText: "Add Something") : Scaffold(appBar: AppBar(toolbarHeight: 75,title: Text("Recently Viewed Products",style: TextStyle(fontWeight: FontWeight.bold,color:textColor),),backgroundColor: Theme.of(context).scaffoldBackgroundColor,actions: [IconButton(
      onPressed: () {
        warningDialog(title: "Do you Want to clear Viewed History?", subtitle: "Are you sure?", fct:(){}, context: context);
      },
      icon: Icon(
        IconlyBroken.delete,
        color: textColor,
      ),
    ),],),body: ListView.separated(itemBuilder: (context,index){
      return Recentviewwidget();
    }, separatorBuilder:(BuildContext context,int index){
      return Divider(thickness: 0.1,);
    }, itemCount: 5),);
  }
}
