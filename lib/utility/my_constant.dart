import 'package:flutter/material.dart';

enum SingingCharacter { buyer, seller, rider }

class MyConstant {
  static String serverAddr = 'http://192.168.1.111';

  static String appName = 'Shopping Mall';

  static String routeAuthen = 'authen';
  static String routeBuyerService = 'buyer_service';
  static String routeCreateAccount = 'create_account';
  static String routeRiderService = 'rider_service';
  static String routeSellerService = 'seller_service';
  static String routeAddProducts = 'add_products';

  static String image1 = 'assets/images/image1.png';
  static String image2 = 'assets/images/image2.png';
  static String image3 = 'assets/images/image3.png';
  static String image4 = 'assets/images/image4.png';
  static String image5 = 'assets/images/shopping-cart.png';
  static String image6 = 'assets/images/Add_tasks.png';
  static String image7 = 'assets/images/photoCapture-512.png';
  static String image8 = 'assets/images/view-512.png';

  static Color primary = Color(0xfff78100);
  static Color light = Color(0xffffb243);
  static Color dark = Color(0xffbd5300);

  static Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(189, 83, 0, 0.1),
    100: Color.fromRGBO(189, 83, 0, 0.2),
    200: Color.fromRGBO(189, 83, 0, 0.3),
    300: Color.fromRGBO(189, 83, 0, 0.4),
    400: Color.fromRGBO(189, 83, 0, 0.5),
    500: Color.fromRGBO(189, 83, 0, 0.6),
    600: Color.fromRGBO(189, 83, 0, 0.7),
    700: Color.fromRGBO(189, 83, 0, 0.8),
    800: Color.fromRGBO(189, 83, 0, 0.9),
    900: Color.fromRGBO(189, 83, 0, 1.0),
  };

  static MaterialColor materialColor =
      MaterialColor(0xffbd5300, mapMaterialColor);

  TextStyle h1Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.bold);
  TextStyle h2Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.bold);
  TextStyle h2WhiteStyle() =>
      TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);
  TextStyle h3Style() =>
      TextStyle(fontSize: 15, color: dark, fontWeight: FontWeight.normal);
  TextStyle h3WhiteStyle() => TextStyle(
      fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal);

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        primary: MyConstant.primary,
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      );

  InputDecoration myInputDecoration(
      {String? label, String? hint, IconData? icons}) {
    return InputDecoration(
      prefixIcon: Icon(
        icons,
        color: MyConstant.dark,
      ),
      labelText: label,
      labelStyle: MyConstant().h3Style(),
      hintText: hint,
      hintStyle: TextStyle(color: MyConstant.light, fontSize: 13),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MyConstant.dark),
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MyConstant.light),
        borderRadius: BorderRadius.circular(30),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MyConstant.light),
        borderRadius: BorderRadius.circular(30),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MyConstant.light),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
