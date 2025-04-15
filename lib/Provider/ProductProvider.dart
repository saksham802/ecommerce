import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  static final List<ProductModel> _productsList = [];

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      productSnapshot.docs.forEach((element) {
        _productsList.insert(
            0,
            ProductModel(
              id: element.get('id'),
              title: element.get('title'),
              imgUrl: element.get('imageUrl'),
              productCategory: element.get('productCategoryName'),
              price: double.parse(
                element.get('price'),
              ),
              saleprice: element.get('salePrice'),
              isOnSale: element.get('isOnSale'),
              isOnPiece: element.get('isPiece'),
            ));
      });
    });
    notifyListeners();
  }

  static List<ProductModel> get productsList {
    return _productsList;
  }

  ProductModel findProductByID(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  static List<ProductModel> get onSaleProductList {
    return _productsList.where((element) => element.isOnSale).toList();
  }

  static List<ProductModel> findByCategory(String categoryName) {
    return _productsList
        .where((element) => element.productCategory
        .toLowerCase()
        .contains(categoryName.toLowerCase()))
        .toList();
  }
  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> _searchList = _productsList
        .where(
          (element) => element.title.toLowerCase().contains(
        searchText.toLowerCase(),
      ),
    )
        .toList();
    return _searchList;
  }

}
