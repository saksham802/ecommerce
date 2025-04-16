import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../Provider/OrderProvider.dart';
import '../../theme/darkthemeprovider.dart';
import '../../widget/EmptyWidget.dart';
import '../../widget/OrderWidget.dart';
import '../../widget/textwidget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;
    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return ordersList.isEmpty
              ? const EmptyScreen(
            title: 'You didn\'t place any order yet',
            subtitle: 'Order something and make me happy :)',
            buttonText: 'Shop now',
            imagePath: 'assets/cart.png',
          )
              : Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              title: Textwidget(
                text: 'Your orders (${ordersList.length})',
                color: color,
                textSize: 24.0,
                isTitle: true,
              ),
              backgroundColor: Theme.of(context)
                  .scaffoldBackgroundColor
                  .withOpacity(0.9),
              leading: IconButton(
                icon: Icon(
                  IconlyBold.arrowLeft,
                  color: color,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: ListView.separated(
              itemCount: ordersList.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 2, vertical: 6),
                  child: ChangeNotifierProvider.value(
                    value: ordersList[index],
                    child: const OrderWidget(),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: color,
                  thickness: 1,
                );
              },
            ),
          );
        });
  }
}
