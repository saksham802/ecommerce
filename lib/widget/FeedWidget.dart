import 'package:ecommerce/innerscreen/ProductPage.dart';
import 'package:ecommerce/widget/Pricewidget.dart';
import 'package:ecommerce/widget/heartbtn.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/darkthemeprovider.dart';

class Feedwidget extends StatefulWidget {
  const Feedwidget({super.key});

  @override
  State<Feedwidget> createState() => _FeedwidgetState();
}

class _FeedwidgetState extends State<Feedwidget> {
  final TextEditingController _quantityTextController = TextEditingController();

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

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.push(context,MaterialPageRoute(builder: (context)=>ProductScreen()));
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FancyShimmerImage(
                    imageUrl: "https://i.postimg.cc/wT7fRyBd/veg.png",
                    height: MediaQuery.sizeOf(context).width*0.21, // Increased height
                    width: MediaQuery.sizeOf(context).width*0.2,boxFit: BoxFit.fill, // Increased width
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Textwidget(
                      text: "Title",
                      color: textColor,
                      textSize: 20,
                      isTitle: true,
                    ),
                    const Heartbtn(),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Pricewidget( salePrice: 2.99,
                        price: 5.9,
                        textPrice: _quantityTextController.text,
                        isOnSale: true,
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
                          width: 50, // Added constraint to prevent overflow
                          child: TextFormField(
                            controller: _quantityTextController,
                            onChanged: (value){setState(() {

                            });},
                            key: const ValueKey("10"),
                            style: TextStyle(color: textColor, fontSize: 18),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            textAlign: TextAlign.center, // Centers the text
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                            ],
                            decoration: InputDecoration(
                              isDense: true, // Reduces default padding
                              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    child: Textwidget(
                      text: 'Add to cart',
                      color: textColor,
                      textSize: 20,
                    ),
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
                        )),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
