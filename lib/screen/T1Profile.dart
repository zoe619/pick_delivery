import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_delivery/model/user.dart';
import 'package:pick_delivery/model/user_data.dart';
import 'package:pick_delivery/screen/T1ProfileUpdate.dart';
import 'package:pick_delivery/services/database.dart';
import 'package:pick_delivery/utilities/constant.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Extension.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';

class T1Profile extends StatefulWidget {
  @override
  _T1ProfileState createState() => _T1ProfileState();
}

class _T1ProfileState extends State<T1Profile>
{
  static var tag = "/T1Profile";

  String userId;

  User user = new User();
  @override
  initState()
  {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).currentUserId;
//    _setupProfileUser();
  }
  _setupProfileUser() async
  {
    User profileUser  = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(userId);
    setState(() {
      user = profileUser;
    });
  }
  Widget counter(String counter, String counterName)
  {
    return Column(
      children: <Widget>[profile(counter), text(counterName, textColor: t1TextColorPrimary, fontSize: textSizeMedium, fontFamily: fontMedium)],
    );
  }

  @override
  Widget build(BuildContext context)
  {
    changeStatusColor(t1_app_background);

    return Scaffold(
      backgroundColor: t1_app_background,
      body: FutureBuilder(
        future: usersRef.doc(userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return ListView(
            children: <Widget>[
              _buildProfileInfo(user),
              Divider(),
            ],
          );
        },
      ),
    );
  }

  _buildProfileInfo(User user)
  {
    final profileImg = new Container(
        margin: new EdgeInsets.symmetric(horizontal: 16.0),
        alignment: FractionalOffset.center,
        child: new CircleAvatar(
          backgroundImage: AssetImage(t1_ic_user1),
          radius: 50,
        ));
    final profileContent = new Container(
      margin: new EdgeInsets.only(top: 55.0),
      decoration: boxDecoration(radius: 10, showShadow: true),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),

            user.name != null ?  text(user.name, textColor: t1TextColorPrimary, fontSize: textSizeNormal, fontFamily: fontMedium) : SizedBox.shrink(),
            user.email != null ? text(user.email, textColor: t1_colorPrimary, fontSize: textSizeMedium, fontFamily: fontMedium) : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: view(),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: EdgeInsets.only(top: 90, left: 2, right: 2),
          physics: ScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Stack(
                    children: <Widget>[profileContent, profileImg],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: boxDecoration(radius: 10, showShadow: true),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        rowHeading(t1_lbl_personal),
                        SizedBox(height: 16),
                        user.name != null ? profileText(user.name) : SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: view(),
                        ),
                        SizedBox(height: 8),
                        user.type != null ? profileText(user.type) : SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: view(),
                        ),
//                          SizedBox(height: 8),
//                          profileText(user.type, maxline: 2),
//                          SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: boxDecoration(radius: 10, showShadow: true),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        rowHeading(t1_lbl_contacts),
                        SizedBox(height: 16),
                        user.phone != null ? profileText(user.phone) : SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: view(),
                        ),
                        SizedBox(height: 8),
                        user.email != null ? profileText(user.email) : SizedBox.shrink(),
                        SizedBox(height: 16.0),
                        Center(child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (_)=>T1ProfileUpdate(user: user),
                              ));
                            },
                            child: text('Update Profile', textColor: t1_colorPrimary, fontSize: textSizeMedium, fontFamily: fontMedium))),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
        TopBar(t1_profile_title),
      ],
    );
  }
}
