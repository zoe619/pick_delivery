
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pick_delivery/model/tokens.dart';
import 'package:pick_delivery/utilities/constant.dart';
import 'package:flutter/services.dart';

class AuthService{


  final FirebaseAuth _auth = FirebaseAuth.instance;


//  getter to check if user is logged in or not and returns d appropriate stream
  Stream<User> get user => _auth.authStateChanges();


  Future<String> signUp(String name, String email, String password, String phone, type) async
  {
    String res;
    try{
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if(authResult.user != null)
      {

        usersRef.doc(authResult.user.uid)
            .set({
          'name': name,
          'email': email,
          'phone': phone,
          'type': type
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

      if(res.user.emailVerified)
      {
        return res.user.uid;
      }
      else{
        return "";
      }

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

    return Future.wait([
      _auth.signOut(),

    ]);
  }






}