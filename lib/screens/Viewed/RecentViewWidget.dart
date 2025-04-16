import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../../Provider/CartProvider.dart';
import '../../Provider/ProductProvider.dart';
import '../../auth/registerPage.dart';
import '../../models/RecentlyViewed.dart';
import '../../services/Global_Method.dart';
import '../../theme/darkthemeprovider.dart';
import '../../widget/textwidget.dart';

class RecentlyViewedWidget extends StatelessWidget {
  const RecentlyViewedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final viewedProdModel = Provider.of<ViewedProdModel>(context);

    final getCurrProduct = productProvider.findProductByID(viewedProdModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.saleprice
        : getCurrProduct.price;

    bool _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FancyShimmerImage(
              imageUrl: getCurrProduct.imgUrl,
              boxFit: BoxFit.fill,
              height: MediaQuery.sizeOf(context).width * 0.27,
              width: MediaQuery.sizeOf(context).width * 0.25,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              children: [
                Textwidget(
                  text: getCurrProduct.title,
                  color: color,
                  textSize: 24,
                  isTitle: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                Textwidget(
                  text: '\$${usedPrice.toStringAsFixed(2)}',
                  color: color,
                  textSize: 20,
                  isTitle: false,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _isInCart
                      ? null
                      : () async {
                    final User? user = FirebaseAuth.instance.currentUser;

                    if (user == null) {
                      GlobalMethod.errorDialog(
                          subtitle: 'No user found, Please login first',
                          context: context);
                      return;
                    }
                    await GlobalMethod.addToCart(
                      productId: getCurrProduct.id,
                      quantity: 1,
                      context: context,
                    );
                    await cartProvider.fetchCart();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _isInCart ? Icons.check : IconlyBold.plus,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
