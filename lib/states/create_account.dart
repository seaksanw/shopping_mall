import 'package:flutter/material.dart';
import 'package:shopping_mall/utility/my_constant.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.dark,
        title: Text('Register new Account'),
      ),
      body: Container(
        child: Text('กรอกข้อมูลเพื่อสมัคร'),
      ),
    );
  }
}
