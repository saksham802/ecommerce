import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/encrypt/EncryptionMethod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/OrderModel.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> _orders = [];

  List<OrderModel> get getOrders => _orders;

  Future<void> fetchOrders() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .get();

      _orders = await Future.wait(ordersSnapshot.docs.map((doc) async {
        final order = OrderModel(
          orderId: doc.get('orderId'),
          userId: doc.get('userId'),
          productId: doc.get('productId'),
          userName: doc.get('userName'),
          price: doc.get('price').toString(),
          imageUrl: doc.get('imageUrl'),
          quantity: doc.get('quantity').toString(),
          orderDate: doc.get('orderDate'),
        );
        return await EncryptionMethod.decryptOrderModel(order);
      }));
      _orders = _orders.reversed.toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }
}