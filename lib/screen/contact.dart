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
          if(contact == null)
          {
            return Center(
              child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
            );
          }

            return ListView(
              children: <Widget>[
               contact != null ? _buildProfileInfo(contact)  : CircularProgressIndicator(),
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

          contact.phone != null ? text(contact.phone, textColor: t1TextColorPrimary,
              fontSize: textSizeNormal, fontFamily: fontMedium) : CircularProgressIndicator(),
            contact.email != null ? text(contact.email, textColor: t1_colorPrimary, fontSize: textSizeMedium, fontFamily: fontMedium) : SizedBox.shrink(),
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
                        rowHeading("Address"),
                        SizedBox(height: 16),
                        contact.address != null ? Text(contact.address, maxLines: 3, style: TextStyle(
                          fontSize: 15.0
                        ),) : SizedBox.shrink(),
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
                        rowHeading("Website"),
                        SizedBox(height: 16),
                        contact.website != null ? profileText(contact.website) : SizedBox.shrink(),
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
        TopBar('Contact Us'),
      ],
    );
  }
}
