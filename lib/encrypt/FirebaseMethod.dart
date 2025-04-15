import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/encrypt/EncryptionMethod.dart';
import 'package:ecommerce/models/OrderModel.dart';
import 'package:encrypt/encrypt.dart' as enc;
class FireBaseMethod{
  static Future<void>addInFireBase(OrderModel order,)async {
    String key=EncryptionMethod.keyEnc.base64;
    String iv=EncryptionMethod.vi.base64;
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.orderId)
          .set({
        'orderId': order.orderId,
        'userId': order.userId,
        'productId': order.productId,
        'userName': order.userName,
        'price': order.price,
        'imageUrl': order.imageUrl,
        'quantity': order.quantity,
        'orderDate': order.orderDate,
        'key':key,
        'iv':iv

      });
    } on Exception catch (e) {
     print("Exception : $e");
    }
  }

}