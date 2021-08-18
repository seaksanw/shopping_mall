import 'package:shopping_mall/utility/my_constant.dart';

class ProductData {
  String? id;
  String? idSeller;
  String? nameSeller;
  String? name;
  String? price;
  String? barcode;
  String? detail;
  String? images;
  String isActive;
  String? date;

  ProductData({
    this.id,
    this.idSeller,
    this.nameSeller,
    this.name,
    this.price,
    this.barcode,
    this.detail,
    this.images,
    this.date,
    this.isActive = "0",
  });

  @override
  String toString() {
    return 'ProductData(id: $id, idSeller: $idSeller, nameSeller: $nameSeller, name: $name, price: $price, barcode: $barcode, detail: $detail, images: $images, isActive: $isActive, date: $date)';
  }

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json['id'] as String?,
        idSeller: json['idSeller'] as String?,
        nameSeller: json['nameSeller'] as String?,
        name: json['name'] as String?,
        price: json['price'] as String?,
        barcode: json['barcode'] as String?,
        detail: json['detail'] as String?,
        images: json['images'] as String?,
        isActive: json['isActive'] as String,
        date: json['date'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'idSeller': idSeller,
        'nameSeller': nameSeller,
        'name': name,
        'price': price,
        'barcode': barcode,
        'detail': detail,
        'images': images,
        'isActive': isActive,
        'date': date,
      };

  String imageUrl(int index) {
    String pathsImages = images.toString().substring(1, images!.length - 1);
    List<String> pathImages = pathsImages.split(",");
    print(pathImages[index]);
    return '${MyConstant.serverAddr}${pathImages[index].replaceFirst(new RegExp(r"^\s+"), "")}';
  }

  List<String> imageUrls() {
    String pathsImages = images.toString().substring(1, images!.length - 1);
    List<String> pathImages = pathsImages.split(",");
    // return pathImages
    //     .map((e) =>
    //         '${MyConstant.serverAddr}${e.replaceFirst(new RegExp(r"^\s+"), "")}')
    //     .toList();
    return pathImages
        .map((e) => '${e.replaceFirst(new RegExp(r"^\s+"), "")}')
        .toList();
  }
}
