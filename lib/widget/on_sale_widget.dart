import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../innerscreen/ProductPage.dart';
import '../models/product_model.dart';
import '../theme/darkthemeprovider.dart';
import 'Pricewidget.dart';
import 'heartbtn.dart';


class OnSaleWidget extends StatelessWidget {
  const OnSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final onsaleproductModel = Provider.of<ProductModel>(context);

    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;
    final Color boxColor = themeState.getDarkTheme
        ? Colors.white.withOpacity(0.2)
        : const Color(0xF2FDFDFF);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>ProductScreen(product: onsaleproductModel))
        );
      },
      child: SizedBox(
        height: 180, // Increased height
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          color: boxColor,
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FancyShimmerImage(
                        width: 80,
                        height: 80,
                        imageUrl: onsaleproductModel.imgUrl,
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        onsaleproductModel.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Pricewidget(
                      salePrice: onsaleproductModel.saleprice,
                      price: onsaleproductModel.price,
                      textPrice: '1',
                      isOnSale: onsaleproductModel.isOnSale,
                    ),
                  ],
                ),

                const SizedBox(width: 12),


                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1KG",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [


                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

