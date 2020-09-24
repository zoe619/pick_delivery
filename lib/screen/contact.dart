import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_delivery/model/contact.dart';
import 'package:pick_delivery/services/database.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Extension.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';


class ContactUs extends StatefulWidget
{
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs>
{

  Contact contact = new Contact();
  @override
  initState()
  {
    super.initState();

  }
  _setupContact() async
  {
    List<Contact> c = await Provider.of<DatabaseService>(context, listen: false).getContact();
    setState(() {
      contact = c[0];
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
        future: _setupContact(),
        builder: (BuildContext context, AsyncSnapshot snapshot)
        {
          if(!snapshot.hasData){
            return Center(
              child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
            );
          }
          return ListView(
            children: <Widget>[
              _buildProfileInfo(contact),
              Divider(),
            ],
          );
        },
      ),
    );
  }

  _buildProfileInfo(Contact contact)
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

            text(contact.phone, textColor: t1TextColorPrimary, fontSize: textSizeNormal, fontFamily: fontMedium),
            text(contact.email, textColor: t1_colorPrimary, fontSize: textSizeMedium, fontFamily: fontMedium),
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
                        profileText(contact.address),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: view(),
                        ),
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
                         profileText(contact.website),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: view(),
                        ),

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
