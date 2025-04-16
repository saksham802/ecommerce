import 'package:ecommerce/Provider/ProductProvider.dart';
import 'package:ecommerce/innerscreen/ProductPage.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/services/Global_Method.dart';
import 'package:ecommerce/widget/Pricewidget.dart';
import 'package:ecommerce/widget/heartbtn.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../Provider/CartProvider.dart';

import '../Provider/WishListProvider.dart';
import '../theme/darkthemeprovider.dart';

class Feedwidget extends StatefulWidget {
  const Feedwidget({super.key});

  @override
  State<Feedwidget> createState() => _FeedwidgetState();
}

class _FeedwidgetState extends State<Feedwidget> {
  final TextEditingController _quantityTextController = TextEditingController();
  bool _isAddedToCart = false;

  @override
  void initState() {
    super.initState();
    _quantityTextController.text = "1";
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
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist = wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductScreen(product: productModel),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FancyShimmerImage(
                    imageUrl: productModel.imgUrl,
                    height: MediaQuery.sizeOf(context).width * 0.21,
                    width: MediaQuery.sizeOf(context).width * 0.2,
                    boxFit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Textwidget(
                        text: productModel.title,
                        color: textColor,
                        textSize: 20,
                        isTitle: true,
                      ),
                    ),
                    Icon(_isAddedToCart?IconlyBold.bag:IconlyLight.bag),
                    HeartBTN(
                      productId: productModel.id,
                      isInWishlist: _isInWishlist,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Pricewidget(
                        salePrice: productModel.saleprice,
                        price: productModel.price,
                        textPrice: _quantityTextController.text,
                        isOnSale: productModel.isOnSale,
                      ),
                    ),
                    Row(
                      children: [
                        Textwidget(
                          text: "KG",
                          color: textColor,
                          textSize: 18,
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            controller: _quantityTextController,
                            onChanged: (_) {
                              setState(() {});
                            },
                            key: const ValueKey("quantity"),
                            style: TextStyle(color: textColor, fontSize: 18),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      final quantity = int.tryParse(_quantityTextController.text) ?? 1;
                      GlobalMethod.addToCart(
                        productId: productModel.id,
                        quantity: quantity,
                        context: context,
                      );
                      cartProvider.fetchCart();
                      setState(() {
                        _isAddedToCart = true;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).cardColor),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    child: Textwidget(
                      text: _isAddedToCart ? 'Added to cart' : 'Add to cart',
                      color: textColor,
                      textSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
