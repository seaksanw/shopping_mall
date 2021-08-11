import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_mall/utility/my_constant.dart';
import 'package:shopping_mall/widgets/show_signout.dart';
import 'package:shopping_mall/widgets/show_title.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  _BuyerServiceState createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  String? user;
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
        title: Text('ลูกค้า account name: $user'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('$user'),
                  accountEmail: Text(''),
                ),
                ListTile(
                  leading: Icon(
                    Icons.filter_1_outlined,
                    size: 32,
                  ),
                  title: ShowTitle(
                      title: 'Show Order', textStyle: MyConstant().h2Style()),
                  subtitle: ShowTitle(
                      title: 'แสดงรายการ การสั่งซื้อ',
                      textStyle: MyConstant().h3Style()),
                )
              ],
            ),
            ShowSignOut(),
          ],
        ),
      ),
      body: Container(
        child: Text('ส่วนของผู้ซื้อ'),
      ),
    );
  }
}
