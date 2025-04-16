import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class GlobalMethod{
  static final FirebaseAuth authInstance = FirebaseAuth.instance;

  static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(children: [
            Image.asset(
              'assets/warningsign.png',
              height: 20,
              width: 20,
              fit: BoxFit.fill,
            ),
            const SizedBox(width: 8),
            const Text('An Error occurred'),
          ]),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.cyan, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(children: [
            Image.asset(
              'assets/warningsign.png',
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
            const SizedBox(width: 8),
            Flexible(flex: 1, child: Text(title)),
          ]),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.cyan, fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                fct();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> addToWishlist({
    required String productId,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    if (user == null) {
      await errorDialog(
        subtitle: "You need to be logged in to add to wishlist",
        context: context,
      );
      return;
    }

    final _uid = user.uid;
    final wishlistId = const Uuid().v4();
    try {
      await FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: "Item has been added to your wishlist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      await errorDialog(subtitle: error.toString(), context: context);
    }
  }

  static Future<void> addToCart({
    required String productId,
    required int quantity,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    if (user == null) {
      await errorDialog(
        subtitle: "You need to be logged in to add to cart",
        context: context,
      );
      return;
    }

    final _uid = user.uid;
    final cartId = const Uuid().v4();
    try {
      await FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': quantity,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: "Item has been added to your cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      await errorDialog(subtitle: error.toString(), context: context);
    }
  }
}