import 'package:ecommerce/services/Global_Method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../Provider/ProductProvider.dart';
import '../Provider/WishListProvider.dart';
import '../auth/registerPage.dart';
import '../theme/darkthemeprovider.dart';

class HeartBTN extends StatefulWidget {
  const HeartBTN({Key? key, required this.productId, this.isInWishlist = false})
      : super(key: key);
  final String productId;
  final bool? isInWishlist;

  @override
  State<HeartBTN> createState() => _HeartBTNState();
}

class _HeartBTNState extends State<HeartBTN> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProductByID(widget.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;
    return GestureDetector(
      onTap: () async {
        setState(() {
          loading = true;
        });
        try {
          final User? user = authInstance.currentUser;

          if (user == null) {
            return;
          }
          if (widget.isInWishlist == false && widget.isInWishlist != null) {
            await GlobalMethod.addToWishlist(
                productId: widget.productId, context: context);
          } else {
            await wishlistProvider.removeOneItem(
                wishlistId:
                wishlistProvider.getWishlistItems[getCurrProduct.id]!.id,
                productId: widget.productId);
          }
          await wishlistProvider.fetchWishlist();
          setState(() {
            loading = false;
          });
        } catch (error) {
          GlobalMethod.errorDialog(subtitle: '$error', context: context);
        } finally {
          setState(() {
            loading = false;
          });
        }
      },
      child: loading
          ? const Padding(
        padding:  EdgeInsets.all(8.0),
        child:  SizedBox(
            height: 20, width: 20, child: CircularProgressIndicator()),
      )
          : Icon(
        widget.isInWishlist != null && widget.isInWishlist == true
            ? IconlyBold.heart
            : IconlyLight.heart,
        size: 22,
        color: widget.isInWishlist != null && widget.isInWishlist == true
            ? Colors.red
            : textColor,
      ),
    );
  }
}
