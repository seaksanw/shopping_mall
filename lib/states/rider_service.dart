import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_mall/widgets/show_signout.dart';

class RiderService extends StatefulWidget {
  const RiderService({Key? key}) : super(key: key);

  @override
  _RiderServiceState createState() => _RiderServiceState();
}

class _RiderServiceState extends State<RiderService> {
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
        title: Text('พนักงานส่ง account user: $user'),
      ),
      drawer: Drawer(
        child: ShowSignOut(),
      ),
      body: Container(
        child: Text('ส่วนของพนักงานส่ง'),
      ),
    );
  }
}
