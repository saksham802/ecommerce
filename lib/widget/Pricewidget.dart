import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/darkthemeprovider.dart';


class Pricewidget extends StatelessWidget {
  const Pricewidget({
    Key? key,
    required this.salePrice,
    required this.price,
    required this.textPrice,
    required this.isOnSale,
  }) : super(key: key);
  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;

    double userPrice = isOnSale? salePrice : price;
    return FittedBox(
        child: Row(
          children: [
            Textwidget(
              text: '\$${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
              color: Colors.green,
              textSize: 18,
            ),
            const SizedBox(
              width: 5,
            ),
            Visibility(
              visible: isOnSale? true :false,
              child: Text(
                '\$${(price * int.parse(textPrice)).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
          ],
        ));
  }
}
