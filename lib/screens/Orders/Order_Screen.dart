import 'package:ecommerce/screens/Orders/Order_Widget.dart';
import 'package:ecommerce/widget/EmptyScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/darkthemeprovider.dart';
import '../../widget/textwidget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isOrderEmpty = true;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Textwidget(
          text: 'Orders', // Dynamically update this based on item count
          color: textColor,
          isTitle: true,
          textSize: 22,
        ),
      ),
      body: isOrderEmpty
          ? Emptyscreen(
        imagePath: "assets/history.png",
        title: "No Orders Yet",
        subtitle: "Check our Products",
        buttonText: "Order Now",
      )
          : ListView.separated(
        itemBuilder: (context, index) {
          return OrderWidget();
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: textColor,
            thickness: 0.1,
          );
        },
        itemCount: 5, // Should be dynamic based on actual orders
      ),
    );
  }
}
