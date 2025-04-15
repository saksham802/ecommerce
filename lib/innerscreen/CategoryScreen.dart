import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
import '../models/product_model.dart';
import '../theme/darkthemeprovider.dart';
import '../widget/EmptyWidget.dart';
import '../widget/FeedWidget.dart';

class CategoryProductsScreen extends StatefulWidget {
  static const routeName = "/CategoryProductsScreen";

  const CategoryProductsScreen({Key? key}) : super(key: key);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> _searchList = [];

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    final productProvider = Provider.of<ProductProvider>(context);

    final List<ProductModel> productByCat =
    ProductProvider.findByCategory(catName);

    final List<ProductModel> displayedProducts = _searchTextController.text.isNotEmpty
        ? productByCat
        .where((product) => product.title
        .toLowerCase()
        .contains(_searchTextController.text.toLowerCase()))
        .toList()
        : productByCat;

    return Scaffold(
      appBar: AppBar(
        title: Text(catName),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: productByCat.isEmpty
          ? const EmptyScreen(
        imagePath: 'assets/box.png',
        title: 'No Products',
        subtitle: 'Sorry, no products found in this category.',
        buttonText: 'Shop Now',
      )
          : SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: TextField(
                  focusNode: _searchTextFocusNode,
                  controller: _searchTextController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Colors.greenAccent, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Colors.greenAccent, width: 1),
                    ),
                    hintText: "Search in $catName",
                    prefixIcon: const Icon(Icons.search),
                    suffix: IconButton(
                      onPressed: () {
                        _searchTextController.clear();
                        _searchTextFocusNode.unfocus();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.close,
                        color: _searchTextFocusNode.hasFocus
                            ? Colors.red
                            : color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            displayedProducts.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No matching products found."),
            )
                : GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.sizeOf(context).width /
                  (MediaQuery.sizeOf(context).height * 0.59),
              children:
              List.generate(displayedProducts.length, (index) {
                return ChangeNotifierProvider.value(
                  value: displayedProducts[index],
                  child: const Feedwidget(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
