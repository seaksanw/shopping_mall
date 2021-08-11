import 'package:flutter/cupertino.dart';
import 'package:shopping_mall/utility/my_constant.dart';

class AccountData {
  String? displayName;
  String? userType;
  String? addr;
  String? tel;
  String? email;
  String? user;
  String? password;
  String? lat;
  String? lng;
  String? photoUrl;
  AccountData(
      {this.displayName,
      this.userType,
      this.addr,
      this.tel,
      this.email,
      this.user,
      this.password,
      this.lat,
      this.lng,
      this.photoUrl});

  @override
  String toString() {
    return 'displayName:$displayName,userType:$userType,addr:$addr,tel:$tel,email:$email,user:$user,password:$password,lat:$lat,lng:$lng:photoUrl:$photoUrl';
  }

  factory AccountData.formatFromJason(Map<String, dynamic> json) => AccountData(
      displayName: json['name'],
      userType: json['type'],
      addr: json['address'],
      tel: json['telephone'],
      email: json['email'],
      user: json['user'],
      password: json['password'],
      lat: json['latitude'],
      lng: json['longitude'],
      photoUrl: json['photo_url']);
}
