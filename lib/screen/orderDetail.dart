import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_delivery/model/contact.dart';
import 'package:pick_delivery/model/order.dart';
import 'package:pick_delivery/services/database.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Extension.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';


class OrderDetail extends StatefulWidget
{
  final Order orders;
  OrderDetail({this.orders});
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail>
{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  initState()
  {
    super.initState();

  }
  String btnStatus;
  String id;


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
      key: _scaffoldKey,
      backgroundColor: t1_app_background,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                widget.orders != null ? _buildProfileInfo(widget.orders)  : CircularProgressIndicator(),
                Divider(),

              ],),


          ),
        ],
      ),
    );
  }

  _buildProfileInfo(Order order)
  {


    String btnText;
    if(order.status == "awaiting pick-up")
    {
      btnText = "Start delivery";
      setState(()
      {
        btnStatus = order.status;
      });
    }
    else if(order.status == "transit")
    {
      btnText = "End delivery";
      setState(() {
        btnStatus = order.status;
      });
    }
    else {
      btnText = order.status;
      btnStatus = order.status;
    }
    setState(() {
      id = order.id;
    });
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
            rowHeading("Sender Details"),
            text(order.senderName, textColor: t1TextColorPrimary,
                fontSize: textSizeNormal, fontFamily: fontMedium),
            text(order.senderPhone, textColor: t1_colorPrimary, fontSize: textSizeMedium, fontFamily: fontMedium),
            Padding(
              padding: const EdgeInsets.all(16),
              child: view(),
            ),

            SizedBox(height: 16),
            rowHeading("Receiver Details"),
            text(order.receiverName, textColor: t1TextColorPrimary,
                fontSize: textSizeNormal, fontFamily: fontMedium),
            text(order.receiverPhone, textColor: t1_colorPrimary, fontSize: textSizeMedium, fontFamily: fontMedium),
            Padding(
              padding: const EdgeInsets.all(16),
              child: view(),
            ),
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
                        rowHeading("Pick up address"),
                        SizedBox(height: 10.0),
                        text(order.pickAddress, fontSize: textSizeNormal, maxLine: 3),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: view(),

                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: view(),
                        ),
                        rowHeading("Delivery up address"),
                        SizedBox(height: 10.0),
                        text(order.deliveryAddress, fontSize: textSizeNormal, maxLine: 3),
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
                        rowHeading("Item"),
                        SizedBox(height: 16),
                         profileText(order.item),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: view(),
                        ),
                        SizedBox(height: 10),
                        rowHeading("Delivery fee"),
                        SizedBox(height: 16),
                        profileText("NGN " +order.amount),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: view(),
                        ),
                        SizedBox(height: 10),
                        rowHeading("Distance in kilometer"),
                        SizedBox(height: 16),
                        profileText(order.distance + " Km"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: view(),
                        ),
                        SizedBox(height: 10),
                        rowHeading("Delivery Status"),
                        SizedBox(height: 16),
                        profileText(order.status),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: view(),
                        ),
                        SizedBox(height: 20.0),
                        Material(
                            elevation: 2,
                            shadowColor: Colors.deepOrangeAccent[200],
                            borderRadius: new BorderRadius.circular(40.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: MaterialButton(
                                  child: text(btnText, fontSize: textSizeLargeMedium, textColor: t1_white, fontFamily: fontMedium),
                                  textColor: t1_white,
                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
                                  color: t1_colorPrimary, onPressed:_submit
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
          TopBar('Order Details'),
      ],
    );
  }
  _showErrorDialog(String errMessage, String status)
  {
    showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: Text(status),
            content: Text(errMessage),
            actions: <Widget>[
              Platform.isIOS
                  ? new CupertinoButton(
                child: Text('Ok'),
                onPressed: ()=>Navigator.pop(context),
              ) : FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);

                  }
              )
            ],
          );
        }
    );

  }

  _submit() async
  {


     if(btnStatus == "completed"){
       return;
     }
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration: new Duration(seconds: 5),
          content:
          new Row(
            children: <Widget>[
              Platform.isIOS
                  ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
              new Text("please wait...")
            ],
          ),
          action: new SnackBarAction(
              label: 'OK',
              onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
        ));




       final dbService = Provider.of<DatabaseService>(context, listen: false);


      try
      {

        if(btnStatus == "awaiting pick-up")
        {
          setState(() {
            btnStatus = "transit";
          });

          List res = await dbService.updateStat(id, btnStatus);
          Map<String, dynamic> map;

          for(int i = 0; i < res.length; i++)
          {
            map = res[i];

          }
          if(map['status'] == "Fail")
          {
            _showErrorDialog(map['msg'], map['status']);
            return;
          }
          else
          {
            _showErrorDialog(map['msg'], map['status']);
            return;
          }

        }
        else if(btnStatus == "transit")
        {
          setState(() {
            btnStatus = "completed";
          });
          List res = await dbService.updateStat(id, btnStatus);
          print(res);
          Map<String, dynamic> map;

          for(int i = 0; i < res.length; i++)
          {
            map = res[i];

          }
          if(map['status'] == "Fail")
          {
            _showErrorDialog(map['msg'], map['status']);
            return;
          }
          else
          {
            _showErrorDialog(map['msg'], map['status']);
            return;
          }

        }

      }
      on PlatformException catch (err) {
      _showErrorDialog(err.message, "Error");
      }
  }
}
