import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
import '../models/product_model.dart';
import '../theme/darkthemeprovider.dart';
import '../widget/FeedWidget.dart';
import '../widget/textwidget.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = "/FeedsScreenState";
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProviders = Provider.of<ProductProvider>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor =
    themeState.getDarkTheme ? Colors.white : Colors.black;

    // 🔍 Filtered product list
    List<ProductModel> allProducts = _searchTextController.text.isNotEmpty
        ? productProviders.searchQuery(_searchTextController.text)
        : ProductProvider.productsList;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            IconlyLight.arrowLeft2,
            color: textColor,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Textwidget(
          text: 'All Products',
          color: textColor,
          textSize: 20.0,
          isTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // 🔍 Search bar
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
                    borderSide:
                    const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  hintText: "What's in your mind",
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
                          : textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          allProducts.isEmpty
              ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'No products found',
                style: TextStyle(fontSize: 18, color: textColor),
              ),
            ),
          )
              : GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: EdgeInsets.zero,
            childAspectRatio: 0.8,
            children: List.generate(allProducts.length, (index) {
              return ChangeNotifierProvider.value(
                value: allProducts[index],
                child: const Feedwidget(),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
