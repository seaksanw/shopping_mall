import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shopping_mall/utility/my_constant.dart';
import 'package:shopping_mall/widgets/show_title.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  SingingCharacter _character = SingingCharacter.buyer;
  String? typeUser = 'buyer';
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.dark,
        title: Text('Register new Account'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ShowTitle(title: 'กรอกข้อมูล', textStyle: MyConstant().h2Style()),
            buildTextFormField(
                size: size, title: 'ชื่อ:', hint: 'Name', icon: Icons.person),
            buildRadioChoose(size),
            ShowTitle(title: 'ข้อมูลทั่วไป', textStyle: MyConstant().h3Style()),
            buildTextFormField(
                size: size, hint: 'ทีอยู่:', icon: Icons.home, maxLine: 4),
            buildTextFormField(
                size: size,
                title: 'เบอร์โทรศัพท์:',
                hint: 'หมายเลขที่ติดต่อได้',
                icon: Icons.phone,
                inputType: TextInputType.number),
            buildEmailFormField(
                size: size,
                title: 'อีเมล:',
                hint: 'example@abc.com',
                icon: Icons.email,
                inputType: TextInputType.number),
            ShowTitle(title: 'สร้าง User', textStyle: MyConstant().h3Style()),
            buildTextFormField(
                size: size,
                title: 'User name:',
                hint: 'กำหนด ชื่อ account',
                icon: Icons.create),
            buildPasswordFormField(
                size: size,
                title: 'รหัสผ่าน:',
                hint: 'กำหนดรหัสผ่าน',
                icon: Icons.create),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(
      {double? size,
      String? title,
      String? hint,
      IconData? icon,
      TextInputType inputType = TextInputType.text,
      int maxLine = 1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size,
          child: TextFormField(
            keyboardType: inputType,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant()
                .myInputDecoration(label: title, hint: hint, icons: icon),
            maxLines: maxLine,
            validator: RequiredValidator(errorText: 'ต้องใส่ข้อมูล'),
            onSaved: (value) {},
          ),
        ),
      ],
    );
  }

  Widget buildEmailFormField(
      {double? size,
      String? title,
      String? hint,
      IconData? icon,
      TextInputType inputType = TextInputType.text,
      int maxLine = 1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size,
          child: TextFormField(
            keyboardType: inputType,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant()
                .myInputDecoration(label: title, hint: hint, icons: icon),
            maxLines: maxLine,
            validator: EmailValidator(errorText: 'รูปแบบ อีเมล ไม่ถูกต้อง'),
            onSaved: (value) {},
          ),
        ),
      ],
    );
  }

  Widget buildPasswordFormField(
      {double? size,
      String? title,
      String? hint,
      IconData? icon,
      TextInputType inputType = TextInputType.text,
      int maxLine = 1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size,
          child: TextFormField(
            keyboardType: inputType,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant()
                .myInputDecoration(label: title, hint: hint, icons: icon),
            maxLines: maxLine,
            validator: MinLengthValidator(6, errorText: 'อย่างน้อย 6 ตัวอักษร'),
            onSaved: (value) {},
          ),
        ),
      ],
    );
  }

  Widget buildRadioChoose(double size) {
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
                });
              }),
        ),
      ],
    );
  }

  RadioListTile<SingingCharacter> buildRadioListTile1(
      String title, SingingCharacter singingCharacter) {
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
