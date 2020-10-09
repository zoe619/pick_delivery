import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pick_delivery/model/T1_model.dart';
import 'package:pick_delivery/model/rider.dart';
import 'package:pick_delivery/model/user_data.dart';
import 'package:pick_delivery/screen/T1Dashboard.dart';
import 'package:pick_delivery/services/database.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1DataGenerator.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';

class Riders extends StatefulWidget {
  static var tag = "/Riders";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RidersState();
  }
}

class RidersState extends State<Riders>
{
  List<T1Model> mListings;
  List<Rider> _riders;

  @override
  void initState() {
    super.initState();
    mListings = getListings();
    _getRiders();
  }

  _getRiders() async
  {
    List<Rider> rider = await Provider.of<DatabaseService>(context, listen: false).getRider();
    setState(() {
      _riders = rider;
    });
  }

  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            TopBar('Riders'),
           _riders == null ? Platform.isIOS ? Center(child: CupertinoActivityIndicator()) :
           Center(child: CircularProgressIndicator()) :
         Expanded(

              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _riders.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index)
                  {
                    if(_riders.length != 0)
                    {
                      return T1ListItem(_riders[index], index);
                    }
                    else{
                      return SizedBox.shrink();
                    }

                  }),
            )
          ],
        ),
      ),
    );
  }
}

class T1ListItem extends StatelessWidget
{
  Rider model;
  int pos;

  T1ListItem(Rider model, int pos)
  {
    this.model = model;
    this.pos = pos;


  }

  @override
  Widget build(BuildContext context)
  {
    var width = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          decoration: boxDecoration(radius: 10, showShadow: true),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () async
                  {


                    await FirebaseFirestore.instance
                        .collection('users').where('email', isEqualTo: model.email)
                        .get()
                        .then((QuerySnapshot querySnapshot) => {
                      querySnapshot.docs.forEach((doc)
                      {
                        Provider.of<UserData>(context, listen: false).riderId = doc.id;

                      })
                    });

                   Provider.of<UserData>(context, listen: false).riderName = model.name;
                   Provider.of<UserData>(context, listen: false).riderEmail = model.email;
                   Provider.of<UserData>(context, listen: false).riderPhone = model.phone;
                   Provider.of<UserData>(context, listen: false).amount = model.fee;
                   if(Provider.of<UserData>(context,listen: false).riderId != null){
                     Navigator.push(context, MaterialPageRoute(
                         builder: (_)=>T1Dashboard()
                     ));
                   }

                  },
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
//                        ClipRRect(
//                          child: Image.asset(
//                            model.img,
//                            width: width / 5.5,
//                            height: width / 6,
//                          ),
//                          borderRadius: BorderRadius.circular(12),
//                        ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(model.name, textColor: t1TextColorPrimary, fontFamily: fontBold, fontSize: textSizeNormal, maxLine: 2),
                                      text('NGN '+ model.fee.toString() + " per kilometer", fontSize: textSizeMedium),
                                    ],
                                  ),
                                  text(model.phone, fontSize: textSizeLargeMedium, textColor: t1TextColorPrimary, fontFamily: fontMedium),
                                ],
                              ),
                            ),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      text(model.address, fontSize: textSizeMedium, maxLine: 2, textColor: t1TextColorPrimary),
                    ],
                  ),
                ),
              ),
              Container(
                width: 4,
                height: 35,
                margin: EdgeInsets.only(top: 16),
                color: pos % 2 == 0 ? t1TextColorPrimary : t1_colorPrimary,
              )
            ],
          ),
        ));
  }
}
