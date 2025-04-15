import 'package:ecommerce/Provider/ProductProvider.dart';
import 'package:ecommerce/models/Cart_Model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/widget/heartbtn.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Provider/CartProvider.dart';
import '../../Provider/WishListProvider.dart';
import '../../theme/darkthemeprovider.dart';


class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final TextEditingController _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;
    final productProvider = Provider.of<ProductProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final currentProduct = productProvider.findProductByID(cartModel.productId);
    final int quantity = cartModel.quantity;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final bool? isInList = wishlistProvider.getWishlistItems.containsKey(currentProduct.id);

    if (_quantityTextController.text != quantity.toString()) {
      _quantityTextController.text = quantity.toString();
    }

    double usedPrice = currentProduct.isOnSale
        ? currentProduct.saleprice
        : currentProduct.price;

    return GestureDetector(
      onTap: () {
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image Container
            Container(
              height: MediaQuery.sizeOf(context).width * 0.25,
              width: MediaQuery.sizeOf(context).width * 0.25,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  imageUrl: currentProduct.imgUrl,
                  height: double.infinity,
                  width: double.infinity,
                  boxFit: BoxFit.fill,
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// Text & Quantity Section
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Textwidget(
                    text: currentProduct.title,
                    color: textColor,
                    textSize: 20,
                    isTitle: true,
                  ),
                  const SizedBox(height: 8),

                  /// Quantity Selector
                  Row(
                    children: [
                      _quantityController(
                        fct: () {
                          if (_quantityTextController.text == '1') return;
                          cartProvider.reduceByOne(currentProduct.id);
                          setState(() {
                            _quantityTextController.text =
                                (int.parse(_quantityTextController.text) - 1)
                                    .toString();
                          });
                        },
                        color: Colors.red,
                        icon: CupertinoIcons.minus,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          style: TextStyle(color: textColor, fontSize: 18),
                          controller: _quantityTextController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp('[0-9]'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v.isEmpty) {
                              setState(() {
                                _quantityTextController.text = '1';
                              });
                            }
                          },
                        ),
                      ),
                      _quantityController(
                        fct: () {
                          cartProvider.increaseByOne(currentProduct.id);
                          setState(() {
                            _quantityTextController.text =
                                (int.parse(_quantityTextController.text) + 1)
                                    .toString();
                          });
                        },
                        color: Colors.green,
                        icon: CupertinoIcons.plus,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// Wishlist + Remove + Price
            Column(
              children: [
                InkWell(
                  onTap: () {
                    cartProvider.removeOneItemfromcart(cartId: cartModel.id,
                      productId: cartModel.productId,
                      quantity: cartModel.quantity,);
                  },
                  child: const Icon(
                    CupertinoIcons.cart_badge_minus,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 5),

                const SizedBox(height: 5),

                Textwidget(
                  text:
                  "\$ ${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(2)}",
                  color: textColor,
                  textSize: 18,
                  maxline: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityController({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          fct();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}

