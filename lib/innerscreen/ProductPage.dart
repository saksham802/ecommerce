import 'package:ecommerce/widget/Pricewidget.dart';
import 'package:ecommerce/widget/heartbtn.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../theme/darkthemeprovider.dart';
import '../widget/textwidget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;

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
          text: '',
          color: textColor,
          textSize: 24.0,
          isTitle: true,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 9, right: 9, top: 50),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: FancyShimmerImage(
                imageUrl: "https://i.postimg.cc/wT7fRyBd/veg.png",
                boxFit: BoxFit.fill,
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(26.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Textwidget(
                        text: "Title",
                        color: textColor,
                        textSize: 25,
                        isTitle: true,
                      ),
                      const Heartbtn(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Textwidget(
                        text: "\$ 2.99",
                        color: Colors.green,
                        textSize: 20,
                        isTitle: true,
                      ),
                      const SizedBox(width: 5),
                      Textwidget(
                        text: "/KG",
                        color: textColor,
                        textSize: 15,
                        isTitle: true,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "\$ 3.99",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Free Delivery",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          CupertinoIcons.minus_rectangle_fill,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        flex: 1,
                        child: TextField(style: TextStyle(color: textColor, fontSize: 18),
                          controller: _quantityTextController,
                          key: const ValueKey('quantity'),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          textAlign: TextAlign.center,
                          cursorColor: Colors.green,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          CupertinoIcons.plus_rectangle_fill,
                          color: Colors.green,
                          size: 40,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Textwidget(
                              text: "Total",
                              color: textColor,
                              textSize: 20,
                              isTitle: true,
                            ),
                            Row(
                              children: [
                                Textwidget(
                                  text: "\$ 2.99",
                                  color: textColor,
                                  textSize: 18,
                                  isTitle: true,
                                ),
                                const SizedBox(width: 5),
                                Textwidget(
                                  text: "/1KG",
                                  color: textColor,
                                  textSize: 15,
                                  isTitle: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Add To Cart",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}