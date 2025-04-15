import 'package:ecommerce/Provider/ProductProvider.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/OrderModel.dart';
import '../theme/darkthemeprovider.dart';



class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final ordersModel = Provider.of<OrderModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProductByID(ordersModel.productId);
    return ListTile(
      subtitle:
      Text('Paid: \$${double.parse(ordersModel.price).toStringAsFixed(2)}'),
      onTap: () {

      },
      leading: FancyShimmerImage(
        width: MediaQuery.sizeOf(context).width * 0.2,
        imageUrl: getCurrProduct.imgUrl,
        boxFit: BoxFit.fill,
      ),
      title: Textwidget(
          text: '${getCurrProduct.title}  x${ordersModel.quantity}',
          color: color,
          textSize: 18),
      trailing: Textwidget(text: orderDateToShow, color: color, textSize: 18),
    );
  }
}
