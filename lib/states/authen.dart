import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_mall/models/account_data.dart';
import 'package:shopping_mall/utility/my_constant.dart';
import 'package:shopping_mall/utility/my_dialog.dart';
import 'package:shopping_mall/widgets/show_image.dart';
import 'package:shopping_mall/widgets/show_title.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool readEyeStatus = true;
  final formKey = GlobalKey<FormState>();
  String? userStr, passwordStr;
  Widget showLogo() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ShowImage(pathImage: MyConstant.image4));
  }

  Widget showAppName() {
    return ShowTitle(
        title: MyConstant.appName, textStyle: MyConstant().h1Style());
  }

  Widget showField(double size) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: size,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            userField(),
            SizedBox(
              height: 20,
            ),
            passwordField(),
          ],
        ),
      ),
    );
  }

  Widget userField() {
    return TextFormField(
      style: TextStyle(color: MyConstant.primary, fontSize: 15),
      decoration: MyConstant().myInputDecoration(
          label: 'User',
          hint: 'Enter user account',
          icons: Icons.account_circle),
      validator: RequiredValidator(errorText: 'ต้องใส่ข้อมูล'),
      onSaved: (value) {
        userStr = value;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      style: TextStyle(color: MyConstant.primary, fontSize: 15),
      obscureText: readEyeStatus,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: MyConstant.dark,
        ),
        suffixIcon: IconButton(
          icon: readEyeStatus
              ? Icon(
                  Icons.remove_red_eye,
                  color: MyConstant.dark,
                )
              : Icon(
                  Icons.remove_red_eye_outlined,
                  color: MyConstant.dark,
                ),
          onPressed: () {
            setState(() {
              readEyeStatus = !readEyeStatus;
            });
          },
        ),
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
        labelText: 'Password:',
        labelStyle: MyConstant().h3Style(),
        hintText: 'Enter your password',
        hintStyle: TextStyle(color: MyConstant.light, fontSize: 15),
      ),
      validator: RequiredValidator(errorText: 'ต้องใส่ข้อมูล'),
      onSaved: (value) {
        passwordStr = value;
      },
    );
  }

  Future<void> userAuthen({String? user, String? password}) async {
    //String alertMassage = 'ERR:0001';
    String urlString =
        '${MyConstant.serverAddr}/shoppingmall/getUserWhereUser.php?isAdd=true&user=$user';
    MyDialog().progressDialog(context); // Add progressDialog (circulaprogress)
    String valueTemp = '';
    try {
      await Dio().get(urlString).then((value) async {
        print(value);
        if (value.toString() != 'null' && value.data.indexOf('Error') < 0) {
          valueTemp = value.data;
          //ต้องแปลงเป็น string (หรือใช้ value.data != 'null') แล้ว check กับ string 'null' ไม่ใช่ null
          print('Has User data');
          var jsonData = json.decode(value.toString())[0];
          AccountData accountData = AccountData.formatFromJason(jsonData);
          print('password : ${jsonData['password']}');
          if (password == jsonData['password']) {
            print(accountData);

            Navigator.pop(context); // remove progressDialog (circulaprogress)
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString('type', accountData.userType.toString());
            preferences.setString('user', accountData.user.toString());
            print(
                'authen idUser-------------------->${accountData.id.toString()}');
            preferences.setString('idUser', accountData.id.toString());

            switch (accountData.userType) {
              case 'buyer':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeBuyerService, (route) => false);
                break;
              case 'seller':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeSellerService, (route) => false);
                break;
              case 'rider':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeRiderService, (route) => false);
                break;
              default:
                MyDialog().normalShowDialog(
                    context, "Invalid user type", 'Please,contact Your admin');
                break;
            }
          } else {
            //alertMassage = 'Password is invalid';
            Navigator.pop(context); // remove progressDialog (circulaprogress)
            MyDialog()
                .normalShowDialog(context, 'Login fail', 'Password is invalid');
          }
        } else {
          print('Don\'t have User data');
          //alertMassage = 'User\'s not found';
          Navigator.pop(context); // remove progressDialog (circulaprogress)
          MyDialog().normalShowDialog(
              context, 'Login fail', 'User\'s not found ( ${value.data} )');
        }
      });
    } on DioError catch (e) {
      print('authen------>throw exception');
      print(e.message);
      Navigator.pop(context); // remove progressDialog (circulaprogress)
      MyDialog().normalShowDialog(context, 'Connection fail', e.message);
    } on FormatException catch (e) {
      Navigator.pop(context);
      MyDialog()
          .normalShowDialog(context, 'Error', e.message + " or " + valueTemp);
    }
  }

  Widget loginButton(double size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50),
      width: size,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(Icons.login),
        label: Text(
          'LOGIN',
          style: TextStyle(letterSpacing: 5.0),
        ),
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            print('USER : $userStr  ,   PASSWORD : $passwordStr');
            userAuthen(user: userStr, password: passwordStr);
          }
        },
      ),
    );
  }

  Widget showToCreateNewAcc() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(title: 'Non user?', textStyle: MyConstant().h3Style()),
        createNewAccButton()
      ],
    );
  }

  Widget createNewAccButton() {
    return TextButton(
      child: Text(
        'Click Here!',
        style: TextStyle(color: MyConstant.light, fontSize: 15),
      ),
      onPressed: () {
        // MaterialPageRoute materialPageRoute =
        //     MaterialPageRoute(builder: (context) {
        //   return CreateAccount();
        // });
        // Navigator.of(context).push(materialPageRoute);
        print('Authen page : ----> Creat new account was pressed.');
        Navigator.of(context).pushNamed(MyConstant.routeCreateAccount);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          color: Colors.white,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  showLogo(),
                  showAppName(),
                  SizedBox(
                    height: 20,
                  ),
                  showField(size),
                  loginButton(size),
                  showToCreateNewAcc(),
                ],
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Text('LOGIN'),
      //   onPressed: () {},
      // ),
    );
  }
}
