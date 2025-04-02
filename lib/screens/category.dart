import 'package:ecommerce/widget/CategoryWidget.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/darkthemeprovider.dart';

class CategoryScreen extends StatefulWidget {

  CategoryScreen({super.key});




  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];
  final List<Map<String,dynamic>> categories=[
    {"name":"Fruits","image":"assets/fruits.png"},
    {"name":"Vegetables","image":"assets/vegetables.jpg"},
    {"name":"Spices","image":"assets/spices.png"},
    {"name":"Grains","image":"assets/grains.png"},
    {"name":"Herbs","image":"assets/herbs.png"},
    {"name":"Nuts","image":"assets/nuts.png"},
  ];
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;
    return(Scaffold(appBar: AppBar(backgroundColor:Theme.of(context).scaffoldBackgroundColor,title: Textwidget(text: "Category",textSize: 25,isTitle: true, color:textColor,),),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 200/200,
          crossAxisSpacing: 20, // Vertical spacing
          mainAxisSpacing: 20, // Horizontal spacing
          children: List.generate(6, (index) {
            return CategoryWidget(
              title: categories[index]['name'],
              image: categories[index]['image'],
              passedColor: gridColors[index],
            );
          }),
        ),
      )));
  }
}
