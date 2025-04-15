import 'package:ecommerce/Provider/CartProvider.dart';
import 'package:ecommerce/Provider/ProductProvider.dart';
import 'package:ecommerce/screens/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';


class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 5), () async {
      final productsProvider =
      Provider.of<ProductProvider>(context, listen: false);
      await productsProvider.fetchProducts();
      final cartProvider = Provider.of<CartProvider>(context,listen: false);
      await cartProvider.fetchCart();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => const BottomNav(),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/Offer1.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          const Center(
            child: SpinKitFadingFour(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
