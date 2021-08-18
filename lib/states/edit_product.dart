import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_mall/models/product_data.dart';
import 'package:shopping_mall/utility/my_constant.dart';
import 'package:shopping_mall/utility/my_dialog.dart';

class EditProduct extends StatefulWidget {
  final ProductData productdata;

  const EditProduct({Key? key, required this.productdata}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  ProductData? productData;
  var productNameController = TextEditingController();
  var productPriceController = TextEditingController();
  var productBarCodeController = TextEditingController();
  var productDetailController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  //List<File> file = [];
  var files = List<File>.filled(4, File(''), growable: true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      productData = widget.productdata;
      productNameController.text = productData!.name!;
      productPriceController.text = productData!.price!;
      productBarCodeController.text = productData!.barcode!;
      productDetailController.text = productData!.detail!;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    productNameController.clear();
    productBarCodeController.clear();
    productDetailController.clear();
    productPriceController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (productData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      List<String> photoUrls = productData!.imageUrls();

      return Scaffold(
          appBar: AppBar(
            title: Text('Edit Product \"${productData!.name}\"'),
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildPhotosCarouselSlider(photoUrls, constraints),
                        buildProductFormField(constraints),
                        buildPriceFormField(constraints),
                        buildBarCodeFormField(constraints),
                        buildDetailFormField(constraints),
                        buildAddProductButton(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }));
    }
  }

  Future<void> processGetImage(ImageSource imageSource, int index) async {
    try {
      var result = await ImagePicker()
          .pickImage(source: imageSource, maxWidth: 1024, maxHeight: 1024);
      setState(() {
        files[index] = File(result!.path);
        //files[index] = file;
      });
    } catch (e) {}
  }

  CarouselSlider buildPhotosCarouselSlider(
      List<String> photoUrls, BoxConstraints constraints) {
    return CarouselSlider(
        options: CarouselOptions(
          height: 400.0,
        ),
        items: photoUrls
            .asMap()
            .entries
            .map((e) => Column(children: [
                  SizedBox(
                    height: 300,
                    width: constraints.maxWidth * 0.7,
                    child: files[e.key].path == ''
                        ? CachedNetworkImage(
                            imageUrl: '${MyConstant.serverAddr}${e.value}',
                            //file[e.key].path == '' ? e.value : file[e.key].path,
                            fit: BoxFit.contain,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                          )
                        : Image.file(
                            files[e.key],
                            fit: BoxFit.contain,
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          color: MyConstant.dark,
                          iconSize: 38,
                          onPressed: () {
                            processGetImage(ImageSource.camera, e.key);
                          },
                          icon: Icon(Icons.photo_camera)),
                      Text(
                        '[-${e.key + 1}-]',
                        //'[-${photoUrls.indexOf(e.value) + 1}-]',
                        style: TextStyle(color: MyConstant.primary),
                      ),
                      IconButton(
                          color: MyConstant.dark,
                          iconSize: 38,
                          onPressed: () {
                            processGetImage(ImageSource.gallery, e.key);
                          },
                          icon: Icon(Icons.photo))
                    ],
                  )
                ]))
            .toList());
  }

  Widget buildProductFormField(BoxConstraints constraints) {
    //productNameController.text = productData!.name!;
    //title: 'ชื่อ:', hint: 'Name', icon: Icons.person
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * .75,
          child: TextFormField(
            autocorrect: false,
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
      ],
    );
  }

  Container buildAddProductButton() {
    return Container(
      //color: Colors.black,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      height: 50,
      child: ElevatedButton.icon(
          icon: Icon(Icons.check),
          label: Text(
            'Confirm Edited',
            style: TextStyle(letterSpacing: 5.0),
          ),
          style: MyConstant().myButtonStyle(),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              await uploadNewPhoto();
            }
          }),
    );
  }

  Future<void> uploadNewPhoto() async {
    print('edit change name to :----->${productNameController.text}');
    int prefix = Random().nextInt(100000);
    List<String> imagesURL = [];
    String apiUploadImages =
        '${MyConstant.serverAddr}/shoppingmall/saveProduct.php';
    imagesURL = List<
        String>.from(productData!.imageUrls().asMap().entries.map((e) => files[
                    e.key]
                .path ==
            ''
        ? e.value
        : '/shoppingmall/products/${productData!.nameSeller}(${e.key})_${productData!.id}_${prefix}_${DateTime.now().microsecondsSinceEpoch.toString()}.jpg'));
    // imagesURL = productData!.imageUrls();
    print('New photos url on server:---------->${imagesURL}');
    for (var file in files) {
      if (file.path != '') {
        String imageFileName = imagesURL[files.indexOf(file)];
        print('New photos in mobile:--------->${imageFileName}');
        Map<String, dynamic> map = Map();
        map['file'] =
            await MultipartFile.fromFile(file.path, filename: imageFileName);
        FormData formData = FormData.fromMap(map);
        try {
          await Dio().post(apiUploadImages, data: formData);
        } on DioError catch (e) {
          MyDialog().normalShowDialog(
              context, 'Upload file Fail', '${e.message.substring(0, 100)}...');
        }
      }
    }
    String filesPath = imagesURL.toString();
    String product = productNameController.text;
    String price = productPriceController.text;
    String barcode = productBarCodeController.text;
    String detail = productDetailController.text;
    String apiUpdateProduct =
        '${MyConstant.serverAddr}/shoppingmall/updateProductById.php';
    try {
      await Dio()
          .post(
              '$apiUpdateProduct?isAdd=true&id=${productData!.id}&name=$product&price=$price&barcode=$barcode&detail=$detail&images=$filesPath')
          .then((value) => Navigator.pop(context));
    } on DioError catch (e) {
      MyDialog().normalShowDialog(
          context, 'Update Product data Fail', '${e.message}');
    }
  }
}
