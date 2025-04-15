import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/OrderModel.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';

class EncryptionMethod {
  static late enc.Key _keyEnc;
  static late enc.IV _vi;
  static final encrypter = enc.Encrypter(enc.AES(_keyEnc));
  static enc.Key get keyEnc => _keyEnc;
  static set keyEnc(enc.Key value) {
    _keyEnc = value;
  }

  static enc.IV get vi => _vi;
  static set vi(enc.IV value) {
    _vi = value;
  }
  static Future<OrderModel> encryptCartItem(OrderModel order) async {
    try {
      final encryptedName = await encryptData(order.userName ?? 'Guest');
      final encryptedPrice = await encryptData(order.price.toString());

      return OrderModel(
        orderId: order.orderId,
        userId: order.userId,
        productId: order.productId,
        userName: encryptedName,
        price: encryptedPrice,
        imageUrl: order.imageUrl,
        quantity: order.quantity,
        orderDate: order.orderDate,
      );
    } catch (e) {
      print('Failed to encrypt: $e');
      throw Exception('Failed to encrypt order data: $e'); // Or rethrow; depending on your error handling needs
    }
  }

  static Future<String> encryptData(String plainText) async {
    try {
      if (plainText.isEmpty) return '';

      final encrypted = encrypter.encrypt(plainText, iv: _vi);
      return '${_vi.base64}:${encrypted.base64}';
    } catch (e) {
      print('Encryption failed: $e');
      return '';
    }
  }

  static Future<String> decryptData(String encryptedData) async {
    try {
      final parts = encryptedData.split(':');
      if (parts.length != 2) throw FormatException('Invalid encrypted format');
      final iv = enc.IV.fromBase64(parts[0]);
      final encrypted = enc.Encrypted.fromBase64(parts[1]);
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      print('Decryption failed: $e');
      return 'Decryption Error';
    }
  }

  static Future<OrderModel> decryptOrderModel(OrderModel order) async {
    try{
      final decryptedName = await decryptData(order.userName);
      final decryptedPrice = await  decryptData(order.price.toString());
      return OrderModel(orderId: order.orderId, userId: order.userId, productId: order.productId, userName: decryptedName, price: decryptedPrice, imageUrl: order.imageUrl, quantity: order.quantity, orderDate: order.orderDate);
    }
    catch(e){
      print("Error");
      throw Exception('Failed to decrypt order data: $e');
    }
  }
  static Future<enc.Key> generateAesKey() async {
    try {
      return enc.Key.fromSecureRandom(32);
    } catch (e) {
      print('Error generating AES key: $e');
      throw Exception('Failed to generate AES key');
    }
  }
}
