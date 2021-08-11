import 'package:flutter/material.dart';

class CustomerOrderSeller extends StatefulWidget {
  const CustomerOrderSeller({Key? key}) : super(key: key);

  @override
  _CustomerOrderSellerState createState() => _CustomerOrderSellerState();
}

class _CustomerOrderSellerState extends State<CustomerOrderSeller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Show customer\'s order'),
    );
  }
}
