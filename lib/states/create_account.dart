import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_mall/models/account_data.dart';
import 'package:shopping_mall/utility/my_constant.dart';
import 'package:shopping_mall/utility/my_dialog.dart';
import 'package:shopping_mall/widgets/show_title.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  SingingCharacter _character = SingingCharacter.buyer;
  String? typeUser = 'buyer';
  String userPhotoFile = '';
  File? file;
  double? lat, lng;
  //AccountData? accountData;
  String? displayName, userType, addr, tel, email, user, password; //, photoUrl;
  //TextEditingController controllerUser = TextEditingController();
  // TextEditingController controllerDname = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
  }

  void checkPermission() async {
    LocationPermission locationPermission;
    bool isOpen = false;
    isOpen = await Geolocator.isLocationServiceEnabled();
    if (isOpen) {
      print('Location service is on.');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever ||
            locationPermission == LocationPermission.denied) {
          MyDialog().aleartLocationService(context,
              'ไม่ได้รับการอนุญาตแชร์ตำแหน่ง', 'กรุณาอนุญาตด้วยค่ะ', true);
        } else {
          //lat and lng
          findLatLng();
        }
      } else if (locationPermission == LocationPermission.deniedForever) {
        MyDialog().aleartLocationService(context,
            'ไม่ได้รับการอนุญาตแชร์ตำแหน่ง', 'กรุณาอนุญาตด้วยค่ะ', true);
      } else {
        // Lat and Lng
        findLatLng();
      }
    } else {
      //print('Location service is off.');
      MyDialog().aleartLocationService(
          context,
          'Location Service (การเข้าถึงตำแหน่งพิกัด) ปิดอยู่ !',
          'กรุณาเปิด ด้วยค่ะ',
          false);
    }
  }

  Future<void> findLatLng() async {
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.dark,
        title: Text('Register new Account'),
        actions: [uploadButton(context)],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              //ใช้ ListView แล้วจะเกิด bug throw missmethod error เลยมาใช้ Column แทน
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowTitle(
                    title: 'กรอกข้อมูล', textStyle: MyConstant().h2Style()),
                buildNameFormField(size),
                buildRadioChoose(size),
                ShowTitle(
                    title: 'ข้อมูลทั่วไป', textStyle: MyConstant().h3Style()),
                buildAddrFormField(size),
                buildTelFormField(size),
                buildEmailFormField(size),
                ShowTitle(
                    title: 'สร้าง User', textStyle: MyConstant().h3Style()),
                buildUserFormField(size),
                buildPasswordFormField(size),
                ShowTitle(title: 'รูปภาพ', textStyle: MyConstant().h2Style()),
                ShowTitle(
                    title:
                        'เป็นรูปภาพแสดงต้วตนของ user (แต่ถ้าไม่สะดวกแชร์เราจะแสดงภาพ default แทน)',
                    textStyle: MyConstant().h3Style()),
                buildPictureImage(size),
                ShowTitle(
                    title: 'พิกัดของคุณ', textStyle: MyConstant().h2Style()),
                buildMap(),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconButton uploadButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          userType = typeUser;
          insertUserData();
          // accountData = AccountData(displayName, userType, addr, tel,
          //     email, user, password, lat, lng, photoUrl);
          // print('create_account:----------->accountData=$accountData');
        } else {
          MyDialog().normalShowDialog(
              context, 'ข้อมูลไม่ครบหรือไม่ถูกต้อง', 'ตรวจสอบด้วยค่ะ');
        }
      },
    );
  }

  Future<void> insertUserData() async {
    //String _user = controllerUser.text;
    String urlStr =
        '${MyConstant.serverAddr}/shoppingmall/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(urlStr).then((value) {
      if (value.data == 'null') {
        print('no $user in database');
        print(value.data);
        processUploadPhotoAndInsertData();
      } else {
        print(value.data);
        MyDialog().normalShowDialog(context, '\'$user\' is already exist',
            'Please, choose another user name');
      }
    });
  }

  Future<void> processUploadPhotoAndInsertData() async {
    if (file == null) {
      processInsertData();
    } else {
      String apiForUpLoadPhoto =
          '${MyConstant.serverAddr}/shoppingmall/saveFile.php ';
      userPhotoFile =
          '$user${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
      print(userPhotoFile);
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: userPhotoFile);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiForUpLoadPhoto, data: data).then((value) {
        userPhotoFile = '/shoppingmall/photo/$userPhotoFile';
        processInsertData();
      });
    }
  }

  Future<void> processInsertData() async {
    String apiInsertUrl =
        '${MyConstant.serverAddr}/shoppingmall/insertAccountData.php?name=$displayName&type=$userType&addr=$addr&tel=$tel&email=$email&user=$user&password=$password&lat=$lat&lng=$lng&photo_url=$userPhotoFile&isAdd=true';
    await Dio().post(apiInsertUrl).then((value) {
      if (value.data == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalShowDialog(
            context, 'Fail to create user', 'Please,Try again.');
      }
    });
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('ID'),
          position: LatLng(lat!, lng!),
          infoWindow:
              InfoWindow(title: 'คุณอยู่ที่นี่', snippet: 'Lat=$lat, Lng=$lng'),
        )
      ].toSet();

  Widget buildMap() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: lat == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildGoogleMap(),
      // : Text('Lat= $lat , Lng=$lng'),
    );
  }

  Widget buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(lat!, lng!), zoom: 18),
      //liteModeEnabled: true,
      markers: setMarker(),
      onMapCreated: (controler) {},
    );
  }

  Future<void> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .pickImage(source: source, maxHeight: 800, maxWidth: 800);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {
      print('create_account--------->error throw');
      print(e);
    }
  }

  Container buildPictureImage(double size) {
    return Container(
      color: MyConstant.dark,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36,
              color: MyConstant.light,
            ),
            onPressed: () {
              chooseImage(ImageSource.camera);
              print(
                  'create_account --------photo add by camera button pressed');
            },
          ),
          Container(
            width: size * .7,
            child: file == null
                ? Image.asset(
                    'assets/images/default2-512.png',
                  )
                : Image.file(file!),
          ),
          IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36,
              color: MyConstant.light,
            ),
            onPressed: () {
              chooseImage(ImageSource.gallery);
              print(
                  'create_account --------photo add by gallery button pressed');
            },
          ),
        ],
      ),
    );
  }

  Widget buildNameFormField(
    double size,
  ) {
    //title: 'ชื่อ:', hint: 'Name', icon: Icons.person
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size,
          child: TextFormField(
            //controller: controllerDname,
            keyboardType: TextInputType.text,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant().myInputDecoration(
                label: 'ชื่อ:', hint: 'Name', icons: Icons.person),
            validator: RequiredValidator(errorText: 'ต้องใส่ข้อมูล'),
            onSaved: (value) {
              displayName = value!.trim();
            },
          ),
        ),
      ],
    );
  }

  Widget buildAddrFormField(double size) {
    // size: size, hint: 'ทีอยู่:', icon: Icons.home, maxLine: 4
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size,
          child: TextFormField(
            //keyboardType: TextInputType.text,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant()
                .myInputDecoration(hint: 'ทีอยู่:', icons: Icons.home),
            maxLines: 4,
            validator: RequiredValidator(errorText: 'ต้องใส่ข้อมูล'),
            onSaved: (value) {
              addr = value;
            },
          ),
        ),
      ],
    );
  }

  Widget buildTelFormField(double size) {
    // size: size,
    // title: 'เบอร์โทรศัพท์:',
    // hint: 'หมายเลขที่ติดต่อได้',
    // icon: Icons.phone,
    // inputType: TextInputType.number
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size,
          child: TextFormField(
            keyboardType: TextInputType.number,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant().myInputDecoration(
                label: 'เบอร์โทรศัพท์:',
                hint: 'หมายเลขที่ติดต่อได้',
                icons: Icons.phone),
            validator: RequiredValidator(errorText: 'ต้องใส่ข้อมูล'),
            onSaved: (value) {
              tel = value;
            },
          ),
        ),
      ],
    );
  }

  Widget buildUserFormField(double size) {
    //         size: size,
    // title: 'User name:',
    // hint: 'กำหนด ชื่อ account',
    // icon: Icons.create
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size,
          child: TextFormField(
            // controller: controllerUser,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant().myInputDecoration(
                label: 'กำหนดชื่อ User :',
                hint: 'ใส่ชื่อ user ที่ต้องการ',
                icons: Icons.create),
            validator: RequiredValidator(errorText: 'ต้องใส่ข้อมูล'),
            onSaved: (value) {
              user = value!.trim();
            },
          ),
        ),
      ],
    );
  }

  Widget buildEmailFormField(double size) {
    //         size: size,
    // title: 'อีเมล:',
    // hint: 'example@abc.com',
    // icon: Icons.email,
    // inputType: TextInputType.number
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          width: size,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant().myInputDecoration(
                label: 'อีเมล:', hint: 'example@abc.com', icons: Icons.email),
            validator: EmailValidator(errorText: 'รูปแบบ อีเมล ไม่ถูกต้อง'),
            onSaved: (value) {
              email = value!.trim();
            },
          ),
        ),
      ],
    );
  }

  Widget buildPasswordFormField(double size) {
    // size: size,
    // title: 'รหัสผ่าน:',
    // hint: 'กำหนดรหัสผ่าน',
    // icon: Icons.create
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 20),
          width: size,
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant().myInputDecoration(
                label: 'กำหนดรหัสผ่าน:',
                hint: 'ใส่รหัสผ่านที่ต้องการ',
                icons: Icons.create),
            validator: MinLengthValidator(6, errorText: 'อย่างน้อย 6 ตัวอักษร'),
            onSaved: (value) {
              password = value!.trim();
            },
          ),
        ),
      ],
    );
  }

  Widget buildRadioChoose(double size) {
    //ใช้อันนี้
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShowTitle(
              title: 'ต้องการสมัครเป็น :', textStyle: MyConstant().h3Style()),
          // buildRadioListTile1('ลูกค้า', SingingCharacter.buyer),
          // buildRadioListTile1('ผู้ขาย', SingingCharacter.seller),
          // buildRadioListTile1('พนักงานส่ง', SingingCharacter.rider),
          buildRadioListTile('ลูกค้า', 'buyer', size),
          buildRadioListTile('ผู้ขาย', 'seller', size),
          buildRadioListTile('พนักงานส่ง', 'rider', size)
        ],
      ),
    );
  }

  Widget buildRadioListTile(String title, String rValue, double size) {
    //ใช้อันนี้
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size,
          child: RadioListTile(
              title: ShowTitle(title: title, textStyle: MyConstant().h3Style()),
              value: rValue,
              groupValue: typeUser,
              onChanged: (value) {
                setState(() {
                  print('create_account ;---------------> $value');
                  typeUser = value as String?;
                  userType = typeUser;
                });
              }),
        ),
      ],
    );
  }

  RadioListTile<SingingCharacter> buildRadioListTile1(
      //ไม่ได้ใช้
      String title,
      SingingCharacter singingCharacter) {
    return RadioListTile<SingingCharacter>(
      title: ShowTitle(title: title, textStyle: MyConstant().h3Style()),
      value: singingCharacter,
      groupValue: _character,
      onChanged: (SingingCharacter? value) {
        print('create_account ;---------------> $value');
        setState(() {
          _character = value!;
        });
      },
    );
  }
}
