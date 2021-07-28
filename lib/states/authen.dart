import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shopping_mall/states/create_account.dart';
import 'package:shopping_mall/utility/my_constant.dart';
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
    return ShowImage(pathImage: MyConstant.image4);
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
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.account_circle,
          color: MyConstant.dark,
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
        // icon: Icon(
        //   Icons.face,
        //   size: 36,
        //   color: MyConstant.dark,
        // ),
        labelText: 'User:',
        labelStyle: MyConstant().h3Style(),
        hintText: 'Enter user account',
        hintStyle: TextStyle(color: MyConstant.light, fontSize: 15),
      ),
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
        // icon: Icon(
        //   Icons.lock,
        //   size: 36,
        //   color: MyConstant.dark,
        // ),
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

  Widget loginButton(double size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50),
      width: size,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(Icons.login),
        label: Text(
          'L O G I N',
        ),
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            print('USER : $userStr  ,   PASSWORD : $passwordStr');
          }
        },
      ),
    );
  }

  Widget createNewAccButton() {
    return TextButton(
      child: Text(
        'I want to Create a new user.',
        style: TextStyle(color: MyConstant.light, fontSize: 15),
      ),
      onPressed: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (context) {
          return CreateAccount();
        });
        Navigator.of(context).push(materialPageRoute);
        print('Authen page : ----> Creat new account was pressed.');
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
                  createNewAccButton(),
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