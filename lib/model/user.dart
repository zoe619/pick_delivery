import 'package:cloud_firestore/cloud_firestore.dart';

class Users
{

  String id;
  String name;
  String email;
  String phone;
  String type;
  String wallet;
  String fee;
  String address;
  String license;
  String regNo;
  String fcm;



  Users({this.id, this.name, this.email, this.phone, this.type, this.wallet, this.fee, this.address,
    this.license, this.regNo, this.fcm});

//  factory User.fromJson(Map<String, dynamic> json)
//  {
//    return User(
//
//      name: json['names'] as String,
//      email: json['email'] as String,
//      phone: json['phone'] as String,
//      password: json['password'] as String,
//      date: json['date_registered'] as String
//
//    );
//  }
  factory Users.fromDoc(DocumentSnapshot doc)
  {
    return Users(
      id: doc.id,
      name: doc.get('name'),
      email: doc.get('email'),
      phone: doc.get('phone'),
      type: doc.get('type'),
      wallet: doc.get('wallet'),
      fee: doc.get('fee'),
      address: doc.get('address'),
      license: doc.get('license'),
      regNo: doc.get('reg_no'),
      fcm: doc.get('fcm')

    );
  }
}