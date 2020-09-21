import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pick_delivery/model/user_data.dart';
import 'package:pick_delivery/screen/T1BottomNavigation.dart';
import 'package:pick_delivery/screen/T1BottomSheet.dart';
import 'package:pick_delivery/screen/T1Card.dart';
import 'package:pick_delivery/screen/T1Dashboard.dart';
import 'package:pick_delivery/screen/T1Dialog.dart';
import 'package:pick_delivery/screen/T1ImageSlider.dart';
import 'package:pick_delivery/screen/T1Listing.dart';
import 'package:pick_delivery/screen/T1Login.dart';
import 'package:pick_delivery/screen/T1Profile.dart';
import 'package:pick_delivery/screen/T1Search.dart';
import 'package:pick_delivery/screen/T1Sidemenu.dart';
import 'package:pick_delivery/screen/T1Signup.dart';
import 'package:pick_delivery/screen/T1WalkThrough.dart';
import 'package:pick_delivery/screen/location.dart';
import 'package:pick_delivery/screen/map.dart';
import 'package:pick_delivery/services/auth_service.dart';
import 'package:pick_delivery/services/database.dart';


import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   runApp(
     MultiProvider(
       providers: [
         ChangeNotifierProvider(
           create: (_)=>UserData(),
         ),
         Provider<DatabaseService> (
           create: (_) => DatabaseService(),
         ),
         Provider<AuthService> (
           create: (_) => AuthService(),
         ),

       ],
       child:  MyApp(),
     ),
   );
}





class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          /**launcher screen routes*/

          /**Theme 1 screens routes*/
          T1Login.tag: (context) => T1Login(),
          'T1Signup': (context) => T1Signup(),
          T1Profile.tag: (context) => T1Profile(),
          T1Dashboard.tag: (context) => T1Dashboard(),
          T1Listing.tag: (context) => T1Listing(),
          T1Dialog.tag: (context) => T1Dialog(),
          T1Card.tag: (context) => T1Card(),
          T1WalkThrough.tag: (context) => T1WalkThrough(),
          T1SideMenu.tag: (BuildContext context) => T1SideMenu(),
          T1BottomNavigation.tag: (BuildContext context) => T1BottomNavigation(),
          T1BottomSheet.tag: (BuildContext context) => T1BottomSheet(),
          T1Search.tag: (BuildContext context) => T1Search(),
          T1ImageSlider.tag: (BuildContext context) => T1ImageSlider(),

        },
        home: StreamBuilder<User>(
          stream: Provider.of<AuthService>(context, listen: false).user,
          builder: (BuildContext context, AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
            {
              Center(
                child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
              );
            }
            if(snapshot.hasData)
            {
//               return Map2();
              Provider.of<UserData>(context, listen: false).currentUserId
              = snapshot.data.uid;
              return T1Dashboard();
            }
            else
            {
              return T1Login();
            }

          },

        ),
      );

  }
}

class SBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
