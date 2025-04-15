import 'package:flutter/foundation.dart';
import 'product_model.dart'; // Import your product model

class CartModel with ChangeNotifier {
  final String id;
  final String productId;
  int quantity;


  CartModel({
    required this.id,
    required this.productId,
    required this.quantity,

  });
}
