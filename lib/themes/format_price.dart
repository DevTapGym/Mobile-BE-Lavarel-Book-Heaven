import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FormatPrice {
  static String formatPrice(double price) {
    String priceStr = price.toStringAsFixed(0);
    String result = '';
    int count = 0;

    for (int i = priceStr.length - 1; i >= 0; i--) {
      if (count == 3) {
        result = '.$result';
        count = 0;
      }
      result = priceStr[i] + result;
      count++;
    }

    return '$resultđ';
  }

  static void testFirebaseAuth() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      debugPrint('✅ Firebase Auth hoạt động!');
    } catch (e) {
      debugPrint('❌ Firebase Auth lỗi: $e');
    }
  }
}
