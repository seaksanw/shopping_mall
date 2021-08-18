import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_mall/models/product_data.dart';
import 'package:shopping_mall/states/edit_product.dart';
import 'package:shopping_mall/utility/my_constant.dart';
import 'package:shopping_mall/utility/my_dialog.dart';
import 'package:shopping_mall/widgets/show_title.dart';

class ManageProductsSeller extends StatefulWidget {
  const ManageProductsSeller({Key? key}) : super(key: key);

  @override
  _ManageProductsSellerState createState() => _ManageProductsSellerState();
}

class _ManageProductsSellerState extends State<ManageProductsSeller> {
  bool isLoaded = false;
  List<ProductData> productsData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrductsFromIDseller();
  }

  int productItems = 0;

  Future<void> getPrductsFromIDseller() async {
    if (productsData.length != 0) {
      productsData.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSeller = preferences.getString('idUser');
    String apiGetProduct =
        '${MyConstant.serverAddr}/shoppingmall/getProductsWhereIDseller.php?isAdd=true&idSeller=$idSeller';
    try {
      var getData = await Dio().get(apiGetProduct);
      if (getData.data != 'null') {
        print(getData.data);
        for (var data in jsonDecode(getData.data)) {
          print(data);
          ProductData productData = ProductData.fromJson(data);
          print('product price: ------>${productData.price}');
          // var productImages = jsonDecode(productData.images.toString());
          // print('images0 url ------>${productImages[0]}');
          productsData.add(productData);
        }
        productItems = productsData.length;
      } else {
        print('product data is null');
      }
      setState(() {
        isLoaded = true;
      });
    } on DioError catch (e) {
      setState(() {
        isLoaded = true;
      });
      print('Error :---------->${e.error}');
      print('Error message :----------->${e.message}');
      MyDialog().normalShowDialog(context, '${e.error}', '${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded
          ? productsData.length == 0
              ? buildNoProductFound()
              : buildListViewBuilder()
          : Center(child: CircularProgressIndicator()),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        child: Text('Add'),
        onPressed: () {
          Navigator.pushNamed(context, MyConstant.routeAddProducts)
              .then((value) {
            getPrductsFromIDseller();
          });
        },
      ),
    );
  }

  Center buildNoProductFound() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShowTitle(
              title: 'No product found', textStyle: MyConstant().h1Style()),
          ShowTitle(
              title: 'Please,Add some products',
              textStyle: MyConstant().h2Style()),
        ],
      ),
    );
  }

  Widget buildListViewBuilder() {
    return LayoutBuilder(
        builder: (context, constrains) => Container(
              child: ListView.builder(
                  itemCount: productsData.length,
                  itemBuilder: (itemBuilder, index) {
                    return Card(
                      child: Row(
                        children: [
                          buildTitlePic(constrains, index),
                          buildTailDetail(constrains, index),
                        ],
                      ),
                    );
                  }),
            ));
  }

  Container buildTailDetail(BoxConstraints constrains, int index) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      //color: Colors.yellow,
      padding: EdgeInsets.all(4),
      width: constrains.maxWidth * 0.5 - 4,
      height: constrains.maxWidth * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShowTitle(
            title: 'ราคา ${productsData[index].price.toString()} บาท',
            textStyle: MyConstant().h2Style(),
          ),
          ShowTitle(
              title: productsData[index].detail.toString(),
              textStyle: MyConstant().h3Style()),
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  iconSize: 28,
                  color: MyConstant.primary,
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProduct(
                                    productdata: productsData[index])))
                        .then((value) => getPrductsFromIDseller());
                  },
                  icon: Icon(Icons.build)),
              IconButton(
                  iconSize: 28,
                  color: Colors.red,
                  onPressed: () {
                    confirmDeleteDialog(index);
                  },
                  icon: Icon(Icons.delete)),
              TextButton(
                onPressed: () {
                  setProductActive(index);
                },
                child: Text(
                  productsData[index].isActive == "1" ? 'Active' : 'Inactive',
                  style: TextStyle(
                      fontSize: 10,
                      color: productsData[index].isActive == "1"
                          ? Colors.green
                          : Colors.red),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void setProductActive(int index) async {
    String? id = productsData[index].id;
    String isActive = productsData[index].isActive == "1" ? "0" : "1";
    String apiUri =
        '${MyConstant.serverAddr}/shoppingmall/setActiveWhereIdProduct.php?isAdd=true&id=$id&isActive=$isActive';
    try {
      var res = await Dio().get(apiUri);
      if (res.data == 'True') {
        setState(() {
          productsData[index].isActive = isActive;
        });
      } else {
        MyDialog().normalShowDialog(context, 'Set Param fail', res.data);
      }
    } on DioError catch (e) {
      MyDialog().normalShowDialog(context, e.error, e.message);
    }
  }

  void confirmDeleteDialog(int index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                        productsData[index].imageUrl(1), //imageUrl0(index),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Image.asset(MyConstant.image8),
                  ),
                ),
                title: ShowTitle(
                  title: 'Delete \"${productsData[index].name.toString()}\"',
                  textStyle: MyConstant().h2Style(),
                ),
                subtitle: ShowTitle(
                    title: 'Are you sure ?', textStyle: MyConstant().h3Style()),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      setDeleteToProduct(index);
                      Navigator.pop(context);
                    },
                    child: Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No'))
              ],
            ));
  }

  Future<void> setDeleteToProduct(int index) async {
    String apiUrl =
        '${MyConstant.serverAddr}/shoppingmall/setDelWhereIdProduct.php?isAdd=true&id=${productsData[index].id}';
    MyDialog().progressDialog(context);
    try {
      var value = await Dio().get(apiUrl);
      Navigator.pop(context);
      if (value.data == 'True' && value.data.indexOf('Error') <= 0) {
        //print('delet value res is =====> ${value.data}')
        setState(() {
          productsData.removeAt(index);
        });
      } else {
        MyDialog().normalShowDialog(context, 'Error', value.data);
      }
    } on DioError catch (e) {
      Navigator.pop(context);
      MyDialog().normalShowDialog(context, 'Delete Fail !', e.message);
    }
  }

  Container buildTitlePic(BoxConstraints constrains, int index) {
    return Container(
      padding: EdgeInsets.all(4),
      width: constrains.maxWidth * 0.5 - 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ShowTitle(
              title: productsData[index].name.toString(),
              textStyle: MyConstant().h2Style()),
          Container(
            width: constrains.maxWidth * 0.5,
            height: constrains.maxWidth * 0.4,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: productsData[index].imageUrl(0), //imageUrl0(index),
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Image.asset(MyConstant.image8),
            ),
          ),
          //Text(imageUrl0(index)),
        ],
      ),
    );
  }
}
