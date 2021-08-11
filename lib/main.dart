import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_mall/states/add_products.dart';
import 'package:shopping_mall/states/authen.dart';
import 'package:shopping_mall/states/buyer_service.dart';
import 'package:shopping_mall/states/create_account.dart';
//import 'package:shopping_mall/states/example.dart';
//import 'package:shopping_mall/states/example2.dart';
import 'package:shopping_mall/states/rider_service.dart';
import 'package:shopping_mall/states/seller_service.dart';
import 'package:shopping_mall/utility/my_constant.dart';

final Map<String, WidgetBuilder> sevicePage = {
  'authen': (BuildContext context) => Authen(),
  'buyer_service': (context) => BuyerService(),
  'create_account': (context) => CreateAccount(),
  'rider_service': (context) => RiderService(),
  'seller_service': (contex) => SellerService(),
  'add_products': (context) => AddProducts(), //
};
String? initRoute;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? typePrefer = preferences.getString('type');
  if (typePrefer?.isEmpty ?? true) {
    initRoute = MyConstant.routeAuthen;
  } else {
    switch (typePrefer) {
      case 'buyer':
        initRoute = MyConstant.routeBuyerService;
        break;
      case 'seller':
        initRoute = MyConstant.routeSellerService;
        break;
      case 'rider':
        initRoute = MyConstant.routeRiderService;
        break;
      default:
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: sevicePage,
      initialRoute: initRoute,
      theme: ThemeData(
        primarySwatch: MyConstant.materialColor,
      ),
      //home: Authen(),
    );
  }
}

//for test (rename MyApp1)
class MyApp1 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,

      // theme: ThemeData(
      //   primarySwatch: Colors.orange,
      // ),
      home: CreateAccount(),
    );
  }
}
