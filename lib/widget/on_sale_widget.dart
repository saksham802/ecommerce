import 'package:ecommerce/innerscreen/ProductPage.dart';
import 'package:ecommerce/widget/Pricewidget.dart';
import 'package:ecommerce/widget/heartbtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../theme/darkthemeprovider.dart';

class OnSaleWidget extends StatelessWidget {
  const OnSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;
    final Color box=themeState.getDarkTheme? Colors.white.withOpacity(.2): Color(0xF2FDFDFF);
    return InkWell(onTap:(){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>ProductScreen()));
    } ,
      child: SizedBox(
        child: Card(
          shape: RoundedRectangleBorder(
           // side: BorderSide(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.circular(13),
          ),
          color: box,
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image with fixed size
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/fruits.png",
                        width: 80,  // Reduced width to fit inside card
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Price below image
                    Pricewidget( salePrice: 2.99,
                      price: 5.9,
                      textPrice:'1',
                      isOnSale: true,),
                  ],
                ),

                 // Space between image and details

                // Right-side content (Weight & Icons)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Weight
                    Text(
                      "1KG",
                      style: TextStyle(color:textColor ,fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    // Icons (Bag & Heart)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("Bag Clicked");
                          },
                          child: Icon(IconlyLight.bag, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Heartbtn(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
