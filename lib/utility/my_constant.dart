import 'package:flutter/material.dart';

class MyConstant {
  static String appName = 'Shopping Mall';

  static String routeAuthen = 'authen';
  static String routeBuyerService = 'buyer_service';
  static String routeCreateAccount = 'create_account';
  static String routeRiderService = 'rider_service';
  static String routeSalerService = 'saler_service';

  static String image1 = 'assets/images/image1.png';
  static String image2 = 'assets/images/image2.png';
  static String image3 = 'assets/images/image3.png';
  static String image4 = 'assets/images/image4.png';
  static String image5 = 'assets/images/shopping-cart.png';

  static Color primary = Color(0xfff78100);
  static Color light = Color(0xffffb243);
  static Color dark = Color(0xffbd5300);

  TextStyle h1Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.bold);
  TextStyle h2Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w700);
  TextStyle h3Style() =>
      TextStyle(fontSize: 14, color: dark, fontWeight: FontWeight.normal);

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        primary: MyConstant.primary,
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      );
}
