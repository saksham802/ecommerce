import 'package:ecommerce/screens/Wishlist/Wishlist_widget.dart';
import 'package:ecommerce/services/Global_Method.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../theme/darkthemeprovider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Textwidget(
          text: 'Wishlist (2)', // Dynamically update this based on item count
          color: textColor,
          isTitle: true,
          textSize: 22,
        ),
        actions: [
          IconButton(
            onPressed: () {
              warningDialog(title: "Do you want to Empty your Wishlist?", subtitle: "Are you Sure?", fct: (){}, context: context);
            }, // Implement wishlist clearing functionality
            icon: Icon(
              IconlyBroken.delete,
              color: textColor,
            ),
          ),
        ],
      ),
      body: MasonryGridView.count(
        crossAxisCount: 2,
        // mainAxisSpacing: 16,
        // crossAxisSpacing: 20,
        itemBuilder: (context, index) {
          return const WishlistWidget();
        },
      ),
    );
  }
}
