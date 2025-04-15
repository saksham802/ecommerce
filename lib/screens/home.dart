
import 'package:card_swiper/card_swiper.dart';
import 'package:ecommerce/Provider/ProductProvider.dart';
import 'package:ecommerce/innerscreen/FeedPage.dart';
import 'package:ecommerce/innerscreen/OnSaleScreen.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/widget/FeedWidget.dart';
import 'package:ecommerce/widget/on_sale_widget.dart';
import 'package:ecommerce/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../theme/darkthemeprovider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> swipimg = [
    'assets/image1.jpeg',
    'assets/image2.jpeg',
    'assets/image3.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    final productProviders = Provider.of<ProductProvider>(context);
    List<ProductModel> allProducts = ProductProvider.productsList;
    List<ProductModel> allSaleProducts = ProductProvider.onSaleProductList;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color textColor = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Swiper Section
            SizedBox(
              height: 250, // Adjust height if needed
              width: double.infinity, // Full width
              child: Swiper(
                autoplay: true,
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    swipimg[index],
                    fit: BoxFit.cover,
                  );
                },
                itemCount: swipimg.length,
                pagination: const SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.white,
                    activeColor: Colors.blue,
                  ),
                ),
                control: const SwiperControl(),
              ),
            ),

            const SizedBox(height: 20), // Space between Swiper and List
            Center(child: TextButton(onPressed: (){Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OnSaleScreen()),
            );
            }, child: Textwidget(text: "View All", color: Colors.blue, textSize: 20,isTitle: true,)))
            // On Sale Section with Rotated Text
            ,Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Rotated "On Sale" Text
                  Column(
                    children: [
                      RotatedBox(
                        quarterTurns: -1,
                        child: Textwidget(
                          text: "On Sale".toUpperCase(),
                          textSize: 22,
                          color: Colors.red,
                          isTitle: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(IconlyLight.discount, color: Colors.red),
                    ],
                  ),

                  const SizedBox(width: 10), // Space between text and list

                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.19,
                      child: ListView.builder(
                        itemCount: allSaleProducts.length < 10 ? allSaleProducts.length : 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: SizedBox(
                              width: 200,
                              child: ChangeNotifierProvider.value(
                                value: allSaleProducts[index],
                                child: const OnSaleWidget(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(text: TextSpan(text: "Our Products",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: textColor))),
                ),Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context) =>  FeedsScreen()));
                  }, child: Text("Browse Product",style: TextStyle(color: Colors.blue,fontSize: 22),)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                children: List.generate(
                  allProducts.length < 4 ? allProducts.length : 4,
                      (index) {
                    return ChangeNotifierProvider.value(
                      value: allProducts[index],
                      child: const Feedwidget(),
                    );
                  },
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
