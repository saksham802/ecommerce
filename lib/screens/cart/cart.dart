import 'package:ecommerce/screens/cart/cart_widget.dart';

import 'package:ecommerce/services/Global_Method.dart';
import 'package:ecommerce/widget/EmptyScreen.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../theme/darkthemeprovider.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isEmpty=true;


  @override

  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;
    return isEmpty?Emptyscreen(imagePath: "assets/cart.png", title:"Whoops!!", subtitle: "Your Cart is Empty", buttonText: "Shop Now"):Scaffold( appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Textwidget(
          text: 'Cart (2)',
          color: textColor,
          isTitle: true,
          textSize: 22,
        ),
        actions: [
          IconButton(
            onPressed: () {
              warningDialog(title: "Do you Want to Empty Cart?", subtitle: "Are you sure?", fct:(){}, context: context);
            },
            icon: Icon(
              IconlyBroken.delete,
              color: textColor,
            ),
          ),
        ]),
      body: Column(
        children: [
          _checkout(ctx: context),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (ctx, index) {
                return CartWidget();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkout({required BuildContext ctx}) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).width * 0.1,
      // color: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [
          Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Textwidget(
                  text: 'Order Now',
                  textSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
          FittedBox(child: Textwidget(text: 'Total: \$0.259', color: textColor, textSize: 18, isTitle: true,))
        ]),
      ),
    );

  }}
