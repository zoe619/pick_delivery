
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pick_delivery/model/tokens.dart';
import 'package:pick_delivery/model/user.dart';
import 'package:pick_delivery/utilities/constant.dart';
import 'package:flutter/services.dart';

class AuthService{


  final FirebaseAuth _auth = FirebaseAuth.instance;


//  getter to check if user is logged in or not and returns d appropriate stream
  Stream<User> get user => _auth.authStateChanges();
  final FirebaseMessaging _messaging = FirebaseMessaging();


  Future<String> signUp(String name, String email, String password, String phone, String type, String address,
      String fee, String license, String wallet, String regNo) async
  {
    String res;
    try{
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if(authResult.user != null)
      {

        String token = await _messaging.getToken();
        usersRef.doc(authResult.user.uid)
            .set({
          'name': name,
          'email': email,
          'phone': phone,
          'type': type,
          'address': address,
          'fee': fee,
          'license': license,
          'wallet': wallet,
          'reg_no': regNo,
          'fcm':token
        });



        try
        {
          authResult.user.sendEmailVerification();
          res = authResult.user.uid;
        }

        catch(e)
        {
          print("An error occured while trying to send email verification");
          res = null;
        }
      }
    }
    on PlatformException catch(err){
      throw(err);
    }
    return res;
  }

  Future<String> login(String email, String password) async {
    try{
      UserCredential res =  await _auth.signInWithEmailAndPassword(email: email, password: password);
      _updateToken();
      return res.user.uid;
//      if(res.user.emailVerified)
//      {
//        return res.user.uid;
//      }
//      else{
//        return "";
//      }

    }
    on PlatformException catch(err)
    {
      throw (err);

    }
  }

  Future<void> sendPasswordReset(String email) async
  {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async
  {

    await _removeToken();
    return Future.wait([
      _auth.signOut(),

    ]);
  }

  Future<void> _removeToken() async
  {

    final currentUser =  _auth.currentUser;
    usersRef.doc(currentUser.uid)
        .update({
      'fcm': ''
     });
  }

  Future<void> _updateToken()async
  {
    final currentUser =  _auth.currentUser;
    final token  = await _messaging.getToken();
    final tokenDoc = await usersRef.doc(currentUser.uid).get();

    if(tokenDoc.exists)
    {
      Users tokenObj  = Users.fromDoc(tokenDoc);

      if(token != tokenObj.fcm && token != "")
      {
        usersRef
            .doc(currentUser.uid)
            .update({'fcm': token});
      }
      else if(token == ''){
        usersRef
            .doc(currentUser.uid)
            .update({'fcm': token});
      }
    }

  }






}