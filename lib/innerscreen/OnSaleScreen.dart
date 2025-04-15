import 'package:ecommerce/widget/on_sale_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
import '../models/product_model.dart';
import '../theme/darkthemeprovider.dart';
import '../widget/textwidget.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSaleTrue=false;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;
    final productProviders = Provider.of<ProductProvider>(context);
    List<ProductModel> allProducts = ProductProvider.onSaleProductList;
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
        title: Textwidget(
          text: 'Products on sale',
          color: textColor,
          textSize: 24.0,
          isTitle: true,
        ),
      ),
        body: isSaleTrue ?Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset("assets/box.png",scale: .4,),
            Text("No Product On Sale Yet!,Stay Tune", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor,),
                ),
          ],
        )
        : GridView.count(
    crossAxisCount: 2,
    padding: EdgeInsets.zero,
    childAspectRatio: 1.2,
    children: List.generate(4, (index) {
    return ChangeNotifierProvider.value(value: allProducts[index],child: OnSaleWidget(),);
    }),
    ));

  }
}