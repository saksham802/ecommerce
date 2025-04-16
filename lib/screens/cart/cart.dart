import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/encrypt/EncryptionMethod.dart';
import 'package:ecommerce/encrypt/FirebaseMethod.dart';
import 'package:ecommerce/models/OrderModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/Provider/CartProvider.dart';
import 'package:ecommerce/Provider/ProductProvider.dart';
import 'package:ecommerce/models/Cart_Model.dart';
import 'package:ecommerce/screens/cart/cart_widget.dart';
import 'package:ecommerce/services/Global_Method.dart';
import 'package:ecommerce/widget/EmptyScreen.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../theme/darkthemeprovider.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  double total = 0.0;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final textColor = themeState.getDarkTheme ? Colors.white : Colors.black;
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartItems = cartProvider.getCartItems;
    final cartItemList = cartItems.values.toList().reversed.toList();
    final User? user = FirebaseAuth.instance.currentUser;


    total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final product = productProvider.findProductByID(value.productId);
      final price = product.isOnSale ? product.saleprice : product.price;
      total += price * value.quantity;
    });

    if (cartItemList.isEmpty) {
      return Emptyscreen(
        imagePath: "assets/cart.png",
        title: "Whoops!!",
        subtitle: "Your Cart is Empty",
        buttonText: "Shop Now",
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Textwidget(
          text: 'Cart (${cartItemList.length})',
          color: textColor,
          isTitle: true,
          textSize: 22,
        ),
        actions: [
          IconButton(
            onPressed: () {
              GlobalMethod.warningDialog(
                title: "Do you Want to Empty Cart?",
                subtitle: "Are you sure?",
                fct: () async {
                  await cartProvider.clearOnlineCart();
                },
                context: context,
              );
            },
            icon: Icon(
              IconlyBroken.delete,
              color: textColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _checkout(
            ctx: context,
            cartProvider: cartProvider,
            productProvider: productProvider,
            user: user,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItemList.length,
              itemBuilder: (ctx, index) {
                return ChangeNotifierProvider.value(
                  value: cartItemList[index],
                  child: CartWidget(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkout({
    required BuildContext ctx,
    required CartProvider cartProvider,
    required ProductProvider productProvider,
    required User? user,
  }) {
    final themeState = Provider.of<DarkThemeProvider>(ctx);
    final textColor = themeState.getDarkTheme ? Colors.white : Colors.black;

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(ctx).width * 0.15,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  if (total <= 0) {
                    Fluttertoast.showToast(
                      msg: "Cart total must be greater than zero.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                    return;
                  }

                  final orderId = const Uuid().v4();

                  for (var entry in cartProvider.getCartItems.entries) {
                    final cartItem = entry.value;
                    final product = productProvider.findProductByID(cartItem.productId);
                    final productPrice = product.isOnSale ? product.saleprice : product.price;

                    final order = OrderModel(
                      orderId: orderId,
                      userId: user!.uid,
                      productId: cartItem.productId,
                      userName: user.displayName ?? 'Guest',
                      price: (productPrice * cartItem.quantity).toString(),
                      imageUrl: product.imgUrl,
                      quantity: cartItem.quantity.toString(),
                      orderDate: Timestamp.now(),
                    );

                    OrderModel encryptedOrder = await EncryptionMethod.encryptCartItem(order);
                    await FireBaseMethod.addInFireBase(encryptedOrder);
                  }

                  Fluttertoast.showToast(
                    msg: "Your order has been placed",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );

                  await cartProvider.clearOnlineCart();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Textwidget(
                    text: 'Order Now',
                    textSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
              child: Textwidget(
                text: 'Total: \$${total.toStringAsFixed(2)}',
                color: textColor,
                textSize: 18,
                isTitle: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
