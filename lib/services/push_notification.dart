import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_delivery/screen/ridersDashboard.dart';

class PushNotification
{
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialize()async
  {
    if(Platform.isIOS)
    {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message)async
      {


      },
      onLaunch: (Map<String, dynamic> message)async
      {

        _serializeNavigate(message);

      },
      onResume: (Map<String, dynamic>message)async{

        _serializeNavigate(message);
      }
     );
  }

  void _serializeNavigate(Map<String, dynamic> message)
  {
     var notificationData = message['data'];
     var view = notificationData['view'];

     if(view != null){
       if(view == "new order"){
         Navigator.push(null, MaterialPageRoute(
           builder: (_)=>RidersDashboard(),
         ));
       }
     }
  }



}