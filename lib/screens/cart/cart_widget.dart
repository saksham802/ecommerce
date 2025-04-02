import 'package:ecommerce/widget/heartbtn.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

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

    return InkWell(
      onTap: () {},
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
                  imageUrl: "https://i.postimg.cc/wT7fRyBd/veg.png",
                  height: double.infinity,
                  width: double.infinity,
                  boxFit: BoxFit.fill,
                ),
              ),
            ),

            const SizedBox(width: 12), // Spacing between image and text

            /// Text & Quantity Section
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Textwidget(
                    text: "Title",
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
                          if (_quantityTextController.text == '1') {
                            return;
                          } else {
                            setState(() {
                              _quantityTextController.text = (int.parse(
                                  _quantityTextController
                                      .text) -
                                  1)
                                  .toString();
                            });
                          }

                        },
                        color: Colors.red,
                        icon: CupertinoIcons.minus,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(  style: TextStyle(color: textColor, fontSize: 18),
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
                          if(_quantityTextController=="1"){
                            return;}
                            else{
                              setState(() {
                                _quantityTextController.text=(int.parse(_quantityTextController.text)+1).toString();
                              });
                          }
                          }
                        ,
                        color: Colors.green,
                        icon: CupertinoIcons.plus,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Spacer to push delete & price column to the right
            const Spacer(),

            /// Price & Delete Section
            Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    CupertinoIcons.cart_badge_minus,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 5),
                const Heartbtn(),
                const SizedBox(height: 5),
                Textwidget(
                  text: '\$0.29',
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
