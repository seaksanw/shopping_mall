import 'package:flutter/material.dart';
import 'package:shopping_mall/utility/my_constant.dart';

class ManageProductsSeller extends StatefulWidget {
  const ManageProductsSeller({Key? key}) : super(key: key);

  @override
  _ManageProductsSellerState createState() => _ManageProductsSellerState();
}

class _ManageProductsSellerState extends State<ManageProductsSeller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Show My Products'),
      floatingActionButton: FloatingActionButton(
        child: Text('Add'),
        onPressed: () {
          Navigator.pushNamed(context, MyConstant.routeAddProducts);
        },
      ),
    );
  }
}
