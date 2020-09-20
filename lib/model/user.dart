import 'package:cloud_firestore/cloud_firestore.dart';

class User
{

  String id;
  String name;
  String email;
  String phone;
  String pick;




  User({this.id, this.name, this.email, this.phone, this.pick});

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
  factory User.fromDoc(DocumentSnapshot doc)
  {
    return User(
      id: doc.id,
      name: doc.get('names'),
      email: doc.get('email'),
      phone: doc.get('phone'),
      pick: doc.get('pick')

    );
  }
}