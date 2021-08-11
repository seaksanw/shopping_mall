import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shopping_mall/states/authen.dart';
import 'package:shopping_mall/utility/my_constant.dart';
import 'package:shopping_mall/widgets/show_image.dart';
import 'package:shopping_mall/widgets/show_title.dart';

class MyDialog {
  void aleartLocationService(
      BuildContext context, String title, String message, bool isPermission) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: ListTile(
              leading: ShowImage(pathImage: MyConstant.image6),
              title: ShowTitle(
                  title:
                      title, //'Location Service (การเข้าถึงตำแหน่งพิกัด) ปิดอยู่ !',
                  textStyle: MyConstant().h2Style()),
              subtitle: ShowTitle(
                  title: message, //'กรุณาเปิด ด้วยค่ะ',
                  textStyle: MyConstant().h3Style()),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.of(context).pop(); //ปิดหน้า showDialog
                  },
                  child: Text('Ok')),
            ],
          );
        }).then((value) async {
      if (isPermission) {
        await Geolocator.openAppSettings();
      } else {
        await Geolocator.openLocationSettings();
      }

      Navigator.pop(
          context); //ปิดหน้า CreateAccount service กลับหน้า Authen service
    });
  }

  void normalShowDialog(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: ListTile(
              leading: Image.asset(MyConstant.image6),
              title: Text(
                title,
                style: MyConstant().h2Style(),
              ),
              subtitle: Text(
                message,
                style: MyConstant().h3Style(),
              ),
            ),
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('Ok'))
            ],
          );
        });
  }

  Future<void> progressDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (builder) {
          return WillPopScope(
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
            onWillPop: () async {
              return false;
            },
          );
        });
  }
}
