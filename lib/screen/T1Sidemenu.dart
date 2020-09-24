import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_delivery/model/user.dart';
import 'package:pick_delivery/model/user_data.dart';
import 'package:pick_delivery/screen/T1Dashboard.dart';
import 'package:pick_delivery/screen/T1Listing.dart';
import 'package:pick_delivery/screen/T1Login.dart';
import 'package:pick_delivery/screen/T1Profile.dart';
import 'package:pick_delivery/screen/contact.dart';
import 'package:pick_delivery/services/auth_service.dart';
import 'package:pick_delivery/services/database.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';

class T1SideMenu extends StatefulWidget
{
  static var tag = "/T1SideMenu";

  @override
  State<StatefulWidget> createState() {
    return T1SideMenuState();
  }
}

class T1SideMenuState extends State<T1SideMenu>
{
  var isCollpased = false;
  final Duration duration = Duration(milliseconds: 300);
  String userId;

  User user = new User();
  @override
  initState(){
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).currentUserId;
    _setupProfileUser();
  }

  _setupProfileUser() async
  {
    User profileUser  = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(userId);
    setState(() {
      user = profileUser;
    });
  }

  Widget menuItem(String name)
  {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            text(name, textColor: t1TextColorPrimary, fontFamily: fontMedium),
            Icon(
              Icons.keyboard_arrow_right,
              color: t1TextColorPrimary,
            )
          ],
        ),
        SizedBox(height: 10),
        Divider(
          height: 0.5,
          color: t1_view_color,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    return Scaffold(

        body:
        user == null ? Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator() : Stack(
      children: <Widget>[
        SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(right: width / 4),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height + 100,
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: t1_white, border: Border.all(width: 3, color: t1_colorPrimary)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(t1_ic_user1),
                          radius: width / 7,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                   user.name != null ? text(user.name, textColor: t1TextColorPrimary, fontFamily: fontBold, fontSize: textSizeNormal) : SizedBox.shrink(),
                   user.email != null  ? text(user.email, textColor: t1_colorPrimary, fontSize: textSizeMedium) : SizedBox.shrink(),
                    SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_)=>T1Dashboard(),
                        ));
                      },
                        child: menuItem('Home')),
                    menuItem('Notifications'),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_)=>T1Listing(),
                        ));
                      },
                        child: menuItem('Delivery History')),
                    menuItem('Payments'),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_)=>T1Profile(),
                        ));
                      },
                        child: menuItem('Profile')),
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_)=>ContactUs(),
                          ));
                        },
                        child: menuItem('Reach us')),
                    SizedBox(height: 20),


                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: GestureDetector(
                          onTap: (){
                            Provider.of<AuthService>(context, listen: false).logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => T1Login()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                            child: text(t1_lbl_logout, textColor: t1_colorPrimary,
                                fontFamily: fontSemibold, fontSize: textSizeNormal)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: duration,
          top: isCollpased ? 0 : 0.2 * height,
          bottom: isCollpased ? 0 : 0.2 * height,
          left: isCollpased ? 0 : 0.8 * width,
          right: isCollpased ? 0 : -0.2 * width,
          child: Material(
            child: Container(
              alignment: Alignment.topLeft,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: boxDecoration(radius: 0, bgColor: t1_app_background, showShadow: true),
              child: SafeArea(
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    setState(() {
                      isCollpased = !isCollpased;
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
