import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/Cart_Model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, CartModel> get getCartItems => _cartItems;

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<void> fetchCart() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    final DocumentSnapshot userDoc =
    await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) return;

    final cartData = userDoc.get('userCart') as List<dynamic>;
    _cartItems.clear(); // Avoid duplicates

    for (var item in cartData) {
      _cartItems.putIfAbsent(
        item['productId'],
            () => CartModel(
          id: item['cartId'],
          productId: item['productId'],
          quantity: item['quantity'],
        ),
      );
    }
    notifyListeners();
  }

  void reduceByOne(String productID) {
    if (_cartItems.containsKey(productID)) {
      _cartItems.update(
        productID,
            (value) => CartModel(
          id: value.id,
          productId: value.productId,
          quantity: value.quantity - 1,
        ),
      );
      notifyListeners();
    }
  }

  void increaseByOne(String productID) {
    if (_cartItems.containsKey(productID)) {
      _cartItems.update(
        productID,
            (value) => CartModel(
          id: value.id,
          productId: value.productId,
          quantity: value.quantity + 1,
        ),
      );
      notifyListeners();
    }
  }

  void removeOneItem(String productID) {
    _cartItems.remove(productID);
    notifyListeners();
  }

  Future<void> removeOneItemfromcart({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'userCart': FieldValue.arrayRemove([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': quantity,
          }
        ])
      });

      _cartItems.remove(productId);
      await fetchCart();
      notifyListeners();
    } catch (e) {
      debugPrint("Error removing item from Firestore: $e");
    }
  }

  Future<void> clearOnlineCart() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'userCart': [],
      });

      _cartItems.clear();
      notifyListeners();
    } catch (e) {
      debugPrint("Error clearing cart: $e");
    }
  }
}
