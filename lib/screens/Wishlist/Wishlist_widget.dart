import 'package:ecommerce/Provider/ProductProvider.dart';
import 'package:ecommerce/Provider/WishListProvider.dart';
import 'package:ecommerce/widget/heartbtn.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/Provider/WishListProvider.dart';
import '../../models/WishListModel.dart';
import '../../models/product_model.dart';
import '../../theme/darkthemeprovider.dart';
import '../../widget/textwidget.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistModel = Provider.of<WishlistModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);

    final getCurrProduct = productProvider.findProductByID(wishlistModel.productId);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final usedPrice = getCurrProduct.isOnSale ? getCurrProduct.saleprice : getCurrProduct.price;

    final bool isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: color.withOpacity(0.2), width: 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 100,
              height: 100,
              child: FancyShimmerImage(
                imageUrl: getCurrProduct.imgUrl,
                boxFit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Textwidget(
                            text: getCurrProduct.title,
                            color: color,
                            textSize: 16.0,
                            isTitle: true,
                          ),
                        ),
                       HeartBTN(
                          productId: getCurrProduct.id,
                          isInWishlist: isInWishlist,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Textwidget(
                      text: '\$${usedPrice.toStringAsFixed(2)}',
                      color: color,
                      textSize: 18.0,
                      isTitle: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
