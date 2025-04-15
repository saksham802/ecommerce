import 'package:ecommerce/screens/Wishlist/Wishlist_widget.dart';
import 'package:ecommerce/services/Global_Method.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../Provider/WishListProvider.dart';
import '../../theme/darkthemeprovider.dart';
import '../../widget/EmptyWidget.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList = wishlistProvider.getWishlistItems.values.toList();

    return wishlistItemsList.isEmpty
        ? const EmptyScreen(
      title: 'Your Wishlist Is Empty',
      subtitle: 'Explore more and shortlist some items',
      imagePath: 'assets/wishlist.png',
      buttonText: 'Add a wish',
    )
        : Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Textwidget(
          text: 'Wishlist (${wishlistItemsList.length})',
          color: textColor,
          isTitle: true,
          textSize: 22,
        ),
        actions: [
          IconButton(
            onPressed: () {
              GlobalMethod.warningDialog(
                title: "Empty Wishlist",
                subtitle: "Are you sure you want to clear your wishlist?",
                fct: () => wishlistProvider.clearOnlineWishlist(),
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
      body: MasonryGridView.count(
        padding: const EdgeInsets.all(8),
        crossAxisCount: 1,
        itemCount: wishlistItemsList.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: wishlistItemsList[index],
            child: const WishlistWidget(),
          );
        },
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
    );
  }
}