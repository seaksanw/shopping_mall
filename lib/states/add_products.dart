import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_mall/utility/my_constant.dart';
import 'package:shopping_mall/utility/my_dialog.dart';
import 'package:shopping_mall/widgets/show_title.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({Key? key}) : super(key: key);

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productBarCodeController = TextEditingController();
  TextEditingController productDetailController = TextEditingController();
  File? file;
  List<File?> files = [];
  final formKey = GlobalKey<FormState>();
  String? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFile();
  }

  Future<void> initialFile() async {
    for (int i = 0; i <= 3; i++) {
      files.add(null);
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();

    user = preferences.getString('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Products'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                buildProductFormField(constraints),
                buildPriceFormField(constraints),
                buildBarCodeFormField(constraints),
                buildDetailFormField(constraints),
                buildImage(constraints),
                buildAddProductButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildAddProductButton() {
    return Container(
      //color: Colors.black,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(Icons.add_box),
        label: Text(
          'Add Product',
          style: TextStyle(letterSpacing: 5.0),
        ),
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          processValidateData();
        },
      ),
    );
  }

  Future<void> processValidateData() async {
    bool chkFile = true;
    if (formKey.currentState!.validate()) {
      print('product name :-------->${productNameController.text}');
      for (File? item in files) {
        // chkFile &= item == null ? false : true;
        // print(item);
        if (item == null) {
          chkFile = false;
        }
      }
      if (chkFile == false) {
        MyDialog().normalShowDialog(
            context, 'Image missing', 'Pleasa,compleate all 4 images');
      } else {
        MyDialog().progressDialog(context);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? user = preferences.getString('user');
        String? idSeller = preferences.getString('idUser');
        String product = productNameController.text;
        String price = productPriceController.text;
        String barcode = productBarCodeController.text;
        String detail = productDetailController.text;
        String apiInsertProduct =
            '${MyConstant.serverAddr}/shoppingmall/insertProduct.php';
        String apiUploadImages =
            '${MyConstant.serverAddr}/shoppingmall/saveProduct.php';
        int prefix = Random().nextInt(100000);
        List<String> imagesURL = [];
        for (var image in files) {
          String imageFileName =
              '${user}(${files.indexOf(image)})_${prefix}_${DateTime.now().microsecondsSinceEpoch.toString()}.jpg';
          imagesURL.add('/shoppingmall/products/$imageFileName');
          print(image);
          print(imageFileName);
          Map<String, dynamic> map = Map();
          map['file'] = await MultipartFile.fromFile(image!.path,
              filename: imageFileName);
          FormData formData = FormData.fromMap(map);
          try {
            await Dio().post(apiUploadImages, data: formData);
          } on DioError catch (e) {
            MyDialog().normalShowDialog(context, 'Upload file Fail',
                '${e.message.substring(0, 100)}...');
          }
        }
        String filesPath = imagesURL.toString();
        try {
          await Dio()
              .post(
                  '$apiInsertProduct?isAdd=true&idSeller=$idSeller&nameSeller=$user&name=$product&price=$price&barcode=$barcode&detail=$detail&images=$filesPath')
              .then((value) => Navigator.pop(context));
        } on DioError catch (e) {
          MyDialog().normalShowDialog(context, 'Insert Product data Fail',
              '${e.message.substring(0, 100)}...');
        }
        Navigator.pop(
            context); //remove progressDialog after transfer files success
      }
    } else {
      MyDialog().normalShowDialog(context, 'ข้อมูลไม่ครบถ้วน', 'กรุณาตรวจสอบ');
    }
  }

  Future<void> processGetImage(ImageSource imageSource, int index) async {
    try {
      var result = await ImagePicker()
          .pickImage(source: imageSource, maxWidth: 1024, maxHeight: 1024);
      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {}
  }

  Future<void> imageChooseTargetDialog(int index) async {
    print('from image number:----------->$index');
    showDialog(
        context: context,
        builder: (builder) => AlertDialog(
              title: ListTile(
                leading: Image.asset(MyConstant.image2),
                title: ShowTitle(
                  title: 'image${index + 1} from ?',
                  textStyle: MyConstant().h2Style(),
                ),
                subtitle: ShowTitle(
                    title: 'Select Source For pickup image ${index + 1}',
                    textStyle: MyConstant().h3Style()),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          processGetImage(ImageSource.camera, index);
                          Navigator.pop(context);
                        },
                        child: Text('Camera')),
                    TextButton(
                        onPressed: () {
                          processGetImage(ImageSource.gallery, index);
                          Navigator.pop(context);
                        },
                        child: Text('Gallory')),
                    // TextButton(
                    //     onPressed: () => Navigator.pop(context),
                    //     child: Text('Cancel')),
                  ],
                ),
              ],
            ));
  }

  Widget buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
            // color: Colors.amberAccent,
            margin: EdgeInsets.only(top: 16),
            // height: constraints.maxHeight * 0.75,
            // width: constraints.maxWidth * 0.75,
            child: file == null
                ? Image.asset(
                    MyConstant.image7,
                    width: constraints.maxWidth * 0.75,
                  )
                : Image.file(
                    file!,
                    width: constraints.maxWidth * 0.75,
                  )),
        Container(
          margin: EdgeInsets.only(top: 10),
          // width: constraints.maxWidth * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                //color: Colors.amberAccent,
                //margin: EdgeInsets.only(top: 16),
                height: 48,
                width: 48,
                child: InkWell(
                  child: files[0] == null
                      ? Image.asset(MyConstant.image8)
                      : Image.file(
                          files[0]!,
                          fit: BoxFit.cover,
                        ),
                  onTap: () => imageChooseTargetDialog(0),
                ),
              ),
              Container(
                //color: Colors.amberAccent,
                //margin: EdgeInsets.only(top: 16),
                height: 48,
                width: 48,
                child: InkWell(
                  child: files[1] == null
                      ? Image.asset(MyConstant.image8)
                      : Image.file(files[1]!, fit: BoxFit.cover),
                  onTap: () => imageChooseTargetDialog(1),
                ),
              ),
              Container(
                //color: Colors.amberAccent,
                //margin: EdgeInsets.only(top: 16),
                height: 48,
                width: 48,
                child: InkWell(
                  child: files[2] == null
                      ? Image.asset(MyConstant.image8)
                      : Image.file(
                          files[2]!,
                          fit: BoxFit.cover,
                        ),
                  onTap: () => imageChooseTargetDialog(2),
                ),
              ),
              Container(
                //color: Colors.amberAccent,
                //margin: EdgeInsets.only(top: 16),
                height: 48,
                width: 48,
                child: InkWell(
                  child: files[3] == null
                      ? Image.asset(MyConstant.image8)
                      : Image.file(
                          files[3]!,
                          fit: BoxFit.cover,
                        ),
                  onTap: () => imageChooseTargetDialog(3),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildProductFormField(BoxConstraints constraints) {
    //title: 'ชื่อ:', hint: 'Name', icon: Icons.person
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * .75,
          child: TextFormField(
            //controller: controllerDname,
            controller: productNameController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant().myInputDecoration(
                label: 'ชื่อ*:',
                hint: 'Product Name',
                icons: Icons.add_shopping_cart),
            validator: RequiredValidator(errorText: 'ต้องใส่ข้อมูล'),
            onSaved: (value) {},
          ),
        ),
        // Text(
        //   '*',
        //   style: TextStyle(color: Colors.red, fontSize: 15),
        // )
      ],
    );
  }

  Widget buildPriceFormField(BoxConstraints constraints) {
    //title: 'ชื่อ:', hint: 'Name', icon: Icons.person
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * .75,
          child: TextFormField(
            controller: productPriceController,
            //controller: controllerDname,
            keyboardType: TextInputType.number,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant().myInputDecoration(
                label: 'ราคา*:',
                hint: 'Product Price',
                icons: Icons.payments_outlined),
            validator: RequiredValidator(errorText: 'ต้องใส่ข้อมูล'),
            onSaved: (value) {},
          ),
        ),
        // Text(
        //   '*',
        //   style: TextStyle(color: Colors.red, fontSize: 15),
        // )
      ],
    );
  }

  Widget buildBarCodeFormField(BoxConstraints constraints) {
    //title: 'ชื่อ:', hint: 'Name', icon: Icons.person
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * .75,
          child: TextFormField(
            controller: productBarCodeController,
            //controller: controllerDname,

            keyboardType: TextInputType.number,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant().myInputDecoration(
                label: 'รหัสบาร์โค๊ด:',
                hint: 'Product Barcode ID',
                icons: Icons.qr_code),
            // validator: RequiredValidator(errorText: 'ต้องใส่ข้อมูล'),
            onSaved: (value) {},
          ),
        ),
      ],
    );
  }

  Widget buildDetailFormField(BoxConstraints constraints) {
    //title: 'ชื่อ:', hint: 'Name', icon: Icons.person
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * .75,
          child: TextFormField(
            controller: productDetailController,
            //controller: controllerDname,
            maxLines: 4,
            // keyboardType: TextInputType.text,
            style: TextStyle(color: MyConstant.primary, fontSize: 15),
            decoration: MyConstant().myInputDecoration(
                // label: 'รายละเอียด:',
                hint: 'Product Detail *',
                icons: Icons.details_rounded),
            validator: RequiredValidator(errorText: 'ต้องใส่ข้อมูล'),
            onSaved: (value) {},
          ),
        ),
        // Text(
        //   '*',
        //   style: TextStyle(color: Colors.red, fontSize: 15),
        // )
      ],
    );
  }
}
