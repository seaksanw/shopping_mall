import 'package:flutter/material.dart';
import 'package:shopping_mall/states/authen.dart';
import 'package:shopping_mall/states/buyer_service.dart';
import 'package:shopping_mall/states/create_account.dart';
import 'package:shopping_mall/states/rider_service.dart';
import 'package:shopping_mall/states/saler_service.dart';
import 'package:shopping_mall/utility/my_constant.dart';

final Map<String, WidgetBuilder> sevicePage = {
  'authen': (BuildContext context) => Authen(),
  'buyer_service': (context) => BuyerService(),
  'create_account': (context) => CreateAccount(),
  'rider_service': (context) => RiderService(),
  'saler_service': (contex) => SalerService(),
};
String? initRoute;
void main() {
  initRoute = MyConstant.routeAuthen;
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
      // theme: ThemeData(
      //   primarySwatch: Colors.orange,
      // ),
      //home: Authen(),
    );
  }
}
