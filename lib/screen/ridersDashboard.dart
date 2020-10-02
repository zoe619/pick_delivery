import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pick_delivery/model/T1_model.dart';
import 'package:pick_delivery/model/order.dart';
import 'package:pick_delivery/model/rider.dart';
import 'package:pick_delivery/model/user.dart';
import 'package:pick_delivery/model/user_data.dart';
import 'package:pick_delivery/screen/T1Dashboard.dart';
import 'package:pick_delivery/screen/orderDetail.dart';
import 'package:pick_delivery/services/database.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1DataGenerator.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';

class RidersDashboard extends StatefulWidget
{
  final String email;
  RidersDashboard({this.email});

  static var tag = "/delivery";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RidersDashboardState();
  }
}

class RidersDashboardState extends State<RidersDashboard>
{
  List<T1Model> mListings;
  List<Order> _orders;
  User user = new User();
  String senderEmail;
  String userId;


  @override
  void initState() {
    super.initState();
    mListings = getListings();
    userId = Provider.of<UserData>(context, listen: false).currentUserId;


  }

  _getOrders() async
  {
    List<Order> orders = await Provider.of<DatabaseService>(context, listen: false).getOrder(widget.email);
    setState(() {
      _orders = orders;
    });

  }
  _setupProfileUser() async
  {
    User profileUser  = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(userId);
    setState(() {
      user = profileUser;
      senderEmail = user.email;
    });
  }
  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      body: FutureBuilder(
          future: _getOrders(),
          builder: (BuildContext context, AsyncSnapshot snapshot)
          {
            if(_orders == null)
            {
              return Center(
                child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
              );
            }

            return Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      TopBar('Delivery history'),
                      Expanded(

                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _orders.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index)
                            {
                              if(_orders.length != 0)
                              {
                                return T1ListItem(_orders[index], index);
                              }
                              else{
                                return Center(
                                  child: text('No Delivery history'),
                                );
                              }

                            }
                        ),
                      )
                    ],
                  ),
                )
            );
          }
      ),
    );

  }
}

class T1ListItem extends StatelessWidget
{
  Order model;
  int pos;
  String status;

  T1ListItem(Order model, int pos)
  {
    this.model = model;
    this.pos = pos;
  }

  @override
  Widget build(BuildContext context)
  {


    status = model.status;

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
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_)=>OrderDetail(orders: model),
                    ));
                  },
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          text(model.item, fontSize: textSizeMedium, maxLine: 2, textColor: t1TextColorPrimary),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 35),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      text(model.senderName, textColor: t1TextColorPrimary, fontFamily: fontBold, fontSize: textSizeNormal, maxLine: 2),
                                    ],
                                  ),
                                  text(model.senderPhone, fontSize: textSizeLargeMedium, textColor: t1TextColorPrimary, fontFamily: fontMedium),
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

                      Column(
                        children: <Widget>[

                          text(status, fontSize: textSizeLargeMedium, textColor: t1_colorPrimary, fontFamily: fontMedium),
                          text(model.time, fontSize: textSizeMedium, maxLine: 2, textColor: t1TextColorPrimary),
                        ],
                      ),
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
