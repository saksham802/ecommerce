import 'package:flutter/foundation.dart';

class ProductModel with ChangeNotifier{
  final String id,title,imgUrl,productCategory;

  ProductModel({required this.id,required  this.title,required  this.imgUrl,required  this.productCategory,
    required  this.price,required  this.saleprice,required  this.isOnSale,required  this.isOnPiece});

  final double price,saleprice;
  final bool isOnSale,isOnPiece;
}