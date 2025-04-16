import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Provider/CartProvider.dart';
import 'package:ecommerce/Provider/ProductProvider.dart';
import 'package:ecommerce/encrypt/EncryptionMethod.dart';
import 'package:ecommerce/screens/bottombar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as enc;
class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 5), () async {
      try {
        final productsProvider =
        Provider.of<ProductProvider>(context, listen: false);
        await productsProvider.fetchProducts();

        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        await cartProvider.fetchCart();

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (doc.exists) {
            final aesKey = doc['key'];
            final aesIV = doc['iv'];
            print('Fetched AES Key: $aesKey');
            print('Fetched AES IV: $aesIV');
            EncryptionMethod.keyEnc=enc.Key.fromBase64(aesKey);
            EncryptionMethod.vi=enc.IV.fromBase64(aesIV);
          } else {
            print('No encryption keys found for this user.');
          }
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const BottomNav()),
        );
      } catch (e) {
        print('Error in FetchScreen init: $e');
      }
    });
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
