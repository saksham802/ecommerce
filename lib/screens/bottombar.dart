import 'package:ecommerce/screens/cart/cart.dart';
import 'package:ecommerce/screens/category.dart';
import 'package:ecommerce/screens/home.dart';
import 'package:ecommerce/screens/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;


import '../theme/darkthemeprovider.dart';
import '../widget/textwidget.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {'label': "Home", 'page': HomeScreen()},
    {'label': "Category", 'page': CategoryScreen()},
    {'label': "Cart", 'page': Cart()},
    {'label': "User", 'page': UserScreen()}
  ];


  void _selectPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;


    return Scaffold(
      //appBar: AppBar(title:Text(_pages[_currentIndex]['label']) ,),
      body: _pages[_currentIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
        selectedItemColor: isDark ? Colors.lightBlue.shade100 : Colors.black87,
        unselectedItemColor: isDark ? Colors.white70 : Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 1 ? IconlyBold.category : IconlyLight.category),
            label: "Category",
          ),
          BottomNavigationBarItem(
            icon:badges.Badge(
    position: badges.BadgePosition.topStart(top: 10),
                badgeStyle:badges.BadgeStyle(badgeColor: Colors.blue),badgeContent: Textwidget(text:"1", color: Colors.white, textSize: 14),
    child:Icon(_currentIndex == 2 ? IconlyBold.bag2 : IconlyLight.bag2)),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 3 ? IconlyBold.user3 : IconlyLight.user3),
            label: "User",
          ),
        ],
      ),
    );
  }
}
