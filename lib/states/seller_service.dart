import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_mall/bodys/customer_order_seller.dart';
import 'package:shopping_mall/bodys/manage_products_seller.dart';
import 'package:shopping_mall/bodys/manage_shop_seller.dart';
import 'package:shopping_mall/states/authen.dart';
import 'package:shopping_mall/utility/my_constant.dart';
import 'package:shopping_mall/widgets/show_signout.dart';
import 'package:shopping_mall/widgets/show_title.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  _SellerServiceState createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  String? user;
  List<Widget> body = [
    CustomerOrderSeller(),
    ManageShopSeller(),
    ManageProductsSeller()
  ];
  int indexBody = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAccount();
  }

  Future<void> getUserAccount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      user = preferences.getString('user');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ผู้ขาย user account : $user'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ListView(
              children: [
                UserAccountsDrawerHeader(
                    accountName: ListTile(
                      leading: Icon(
                        Icons.person_rounded,
                        color: MyConstant.light,
                      ),
                      title: ShowTitle(
                          title: '$user',
                          textStyle: MyConstant().h3WhiteStyle()),
                    ),
                    accountEmail: null),
                showCustomerOrder(),
                showMangeShop(),
                showProducts(),
              ],
            ),
            ShowSignOut(),
          ],
        ),
      ),
      body: body[indexBody],
    );
  }

  ListTile showCustomerOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexBody = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.filter_1,
        color: MyConstant.primary,
        size: 32,
      ),
      title:
          ShowTitle(title: 'Customer Order', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
          title: 'แสดงรายการที่ลูกค้าสั่ง', textStyle: MyConstant().h3Style()),
    );
  }

  ListTile showMangeShop() {
    return ListTile(
      onTap: () {
        setState(() {
          indexBody = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.filter_2,
        color: MyConstant.primary,
        size: 32,
      ),
      title:
          ShowTitle(title: 'Mange My Shoop', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
          title: 'แสดงรายรายละเอียดให้ลูกค้าเห็น',
          textStyle: MyConstant().h3Style()),
    );
  }

  ListTile showProducts() {
    return ListTile(
      onTap: () {
        setState(() {
          indexBody = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.filter_3,
        color: MyConstant.primary,
        size: 32,
      ),
      title: ShowTitle(title: 'Products', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
          title: 'แสดงสินค้าที่ขาย', textStyle: MyConstant().h3Style()),
    );
  }
}
