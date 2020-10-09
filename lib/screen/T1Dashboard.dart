import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pick_delivery/model/T1_model.dart';
import 'package:pick_delivery/model/order.dart';
import 'package:pick_delivery/model/user.dart';
import 'package:pick_delivery/model/user_data.dart';
import 'package:pick_delivery/screen/T1Listing.dart';
import 'package:pick_delivery/screen/T1Sidemenu.dart';
import 'package:pick_delivery/screen/location.dart';
import 'package:pick_delivery/screen/orderDetail.dart';
import 'package:pick_delivery/screen/pay.dart';
import 'package:pick_delivery/screen/pay2.dart';
import 'package:pick_delivery/screen/riders.dart';
import 'package:pick_delivery/screen/ridersDashboard.dart';
import 'package:pick_delivery/services/database.dart';
import 'package:pick_delivery/services/push_notification.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Extension.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';

class T1Dashboard extends StatefulWidget
{
  static var tag = "/T1Dashboard";
  String userId;
  String pickAddress;
  String destinationAddress;
  int mapId;

  T1Dashboard({this.mapId});

  @override
  State<StatefulWidget> createState() {
    return T1DashboardState();
  }
}

class T1DashboardState extends State<T1Dashboard>
{
  var isSelected = 1;
  var width;
  var height;
  final _pickFormKey = GlobalKey<FormState>();
  final _deliveryFormKey = GlobalKey<FormState>();
  final _noteFormKey = GlobalKey<FormState>();
  final _riderFormKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _mapFormKey = GlobalKey<FormState>();


  String item, email, phone, pick, pick_address, delivery_address, delivery_name, delivery_phone,
      delivery_email, note, rider;
  bool _isLoading = false;
  bool pick_show = false;
  bool delivery_show = false;
  bool note_show = false;
  bool rider_show = false;

  Icon pick_icon = Icon(Icons.add);
  Icon delivery_icon = Icon(Icons.add);
  Icon note_icon = Icon(Icons.add);
  Icon rider_icon = Icon(Icons.add);
  double distance, amount;

  PushNotification _fcm = new PushNotification();



  TextEditingController pickController = new TextEditingController();
  TextEditingController destinationController = new TextEditingController();
  TextEditingController itemController = new TextEditingController();
  TextEditingController pickPhoneController = new TextEditingController();
  TextEditingController riderController = new TextEditingController();

  TextEditingController deliveryNameController = new TextEditingController();
  TextEditingController deliveryPhoneController = new TextEditingController();
  TextEditingController deliveryEmailController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();

  String userId;
  Users user = new Users();

  List<T1Model> mListings;
  List<Order> _orders;

  String senderEmail;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fcm.initialize();
    userId = Provider.of<UserData>(context, listen: false).currentUserId;
    _setupProfileUser();

    if(widget.mapId == 1)
    {

      pick_show = true;
      pick_icon = Icon(Icons.cancel);
      pickController.text = Provider.of<UserData>(context, listen: false).pickAddress;
    }
    else{
      pickController.text = Provider.of<UserData>(context, listen: false).pickAddress;
    }
    if(widget.mapId == 2)
    {

      delivery_show = true;
      delivery_icon = Icon(Icons.cancel);
      destinationController.text = Provider.of<UserData>(context, listen: false).deliveryAddress;
      itemController.text = Provider.of<UserData>(context, listen: false).pickItem;
    }
    else{
      destinationController.text = Provider.of<UserData>(context, listen: false).deliveryAddress;
    }
    if(Provider.of<UserData>(context, listen: false).riderName != null)
    {

      rider_show = true;
      rider_icon = Icon(Icons.cancel);
      riderController.text = Provider.of<UserData>(context, listen: false).riderName;
      deliveryNameController.text = Provider.of<UserData>(context, listen: false).deliveryName;
      deliveryPhoneController.text = Provider.of<UserData>(context, listen: false).deliveryPhone;
      deliveryEmailController.text = Provider.of<UserData>(context, listen: false).deliveryEmail;
      itemController.text = Provider.of<UserData>(context, listen: false).pickItem;
      noteController.text = Provider.of<UserData>(context, listen: false).note;


    }



  }

  _setupProfileUser() async
  {
    Users profileUser  = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(userId);
    setState(() {
      user = profileUser;
    });
    _getOrders();
  }

  _getOrders() async
  {
    List<Order> orders = await Provider.of<DatabaseService>(context, listen: false).getOrder(user.email);
    setState(() {
      _orders = orders;
    });

  }


  pickupForm()
  {
    return Form(
      key: _pickFormKey,
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_)=>Map2(id:1),
                  ));
                },
                readOnly: true,
                controller: pickController,
                keyboardType: TextInputType.text,
                validator:(input)=>
                input.trim().isEmpty  ? 'Input field is empty' : null,
                onSaved:(input)=>pick_address = input,
                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                  hintText: 'Pick up address',
                  filled: true,
                  fillColor: t1_edit_text_background,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                ),
              )
          ),
          SizedBox(height: 16.0),
          Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: itemController,
                keyboardType: TextInputType.text,
                validator:(input)=>
                input.trim().isEmpty  ? 'Input field is empty' : null,
                onSaved:(input){item = input;
                 itemController.text = input;
                },
                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                  hintText: 'Item to pick up',
                  filled: true,
                  fillColor: t1_edit_text_background,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                ),
              )
          ),
          SizedBox(height: 16),

        ],
      ),
    );

  }
  deliveryForm()
  {
    return Form(
      key: _deliveryFormKey,
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                onTap: (){
                  bool ret = _savePickForm();
                  if(ret){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_)=>Map2(id:2),
                    ));
                  }


                },
                controller: destinationController,
                keyboardType: TextInputType.text,
                validator:(input)=>
                input.trim().isEmpty  ? 'Input field is empty' : null,
                onSaved:(input)=>delivery_address = input,
                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                  hintText: 'Delivery address',
                  filled: true,
                  fillColor: t1_edit_text_background,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                ),
              )
          ),
          SizedBox(height: 16.0),
          Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: deliveryNameController,
                keyboardType: TextInputType.text,
                validator:(input)=>
                input.trim().isEmpty  ? 'Input field is empty' : null,
                onSaved:(input)=>delivery_name = input,
                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                  hintText: 'Receiver\'s name',
                  filled: true,
                  fillColor: t1_edit_text_background,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                ),
              )
          ),
          SizedBox(height: 16),
          Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: deliveryPhoneController,
                keyboardType: TextInputType.phone,
                validator:(input)=>
                input.trim().isEmpty  ? 'Input field is empty' : null,
                onSaved:(input)=>delivery_phone = input,
                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                  hintText: 'Receiver\'s phone',
                  filled: true,
                  fillColor: t1_edit_text_background,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                ),
              )
          ),
          SizedBox(height: 16),
          Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: deliveryEmailController,
                keyboardType: TextInputType.emailAddress,
                validator:(input)=>
                input.trim().isEmpty  ? 'Input field is empty' : null,
                onSaved:(input)=>delivery_email = input,
                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                  hintText: 'Receiver\'s email',
                  filled: true,
                  fillColor: t1_edit_text_background,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
                  ),
                ),
              )
          ),
          SizedBox(height: 16),

        ],
      ),
    );

  }

  noteForm(){
    return Form(
      key: _noteFormKey,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextFormField(
              controller: noteController,
              validator:(input)=>
              input.trim().isEmpty  ? 'Note is empty' : null,
            onSaved:(input)=>note = input,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(24, 10, 24, 10),
              hintText: 'extra note',

            ))),
    );
  }
  riderForm(){
    return Form(
      key: _riderFormKey,
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            onTap: ()
            {
              bool ret = _saveDeliveryForm();

                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => Riders(),
                ));

            },
            readOnly: true,
            controller: riderController,
            keyboardType: TextInputType.text,
            validator:(input)=>
            input.trim().isEmpty  ? 'Rider is empty' : null,
            onSaved:(input)=>rider = input,
            style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
            obscureText: false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
              hintText: 'Pick a rider',
              filled: true,
              fillColor: t1_edit_text_background,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(color: t1_edit_text_background, width: 0.0),
              ),
            ),
          )
      ),
    );
  }

  _showErrorDialog(String errMessage)
  {
    showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: Text('Response'),
            content: Text(errMessage),
            actions: <Widget>[
              Platform.isIOS
                  ? new CupertinoButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.pop(context),
              ) : FlatButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.pop(context),
              )
            ],
          );
        }
    );

  }

  _submit() async
  {



        if(Provider.of<UserData>(context,listen: false).riderName == null)
        {
           return;
        }
       try {



           Navigator.push(context, MaterialPageRoute(
               builder: (_) =>
                   Pay(item: Provider.of<UserData>(context, listen: false).pickItem,
                       deliveryName: Provider.of<UserData>(context, listen: false).deliveryName,
                       deliveryPhone: Provider.of<UserData>(context, listen: false).deliveryPhone,
                       deliveryEmail: Provider.of<UserData>(context, listen: false).deliveryEmail,
                       note: Provider.of<UserData>(context, listen: false).note)
           ));

       }
       on PlatformException catch (err) {
         _showErrorDialog(err.message);
       }

  }


  @override
  Widget build(BuildContext context)
  {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    changeStatusColor(Colors.white);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: t1_white,

      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 80),
            physics: ScrollPhysics(),
            child: Container(
              child: Column(
                children: <Widget>[
                  user != null ?
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: text('Start a delivery', textColor: t1TextColorPrimary,
                                fontSize: textSizeNormal, fontFamily: fontBold),
                          ),
                          SizedBox(height: 10),
                          user.type == "Customer" ?
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>
                              [

                                Container(
                                  decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.white),
                                  width: width,
                                  height: height * 1.6,
                                  child: Form(
                                    key: _mapFormKey,
                                    child: Column(
                                      children: <Widget>[
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.local_grocery_store),
                                            title: Text('Pick-Up Details'),
                                            trailing: GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    if(pick_show == false)
                                                    {
                                                      pick_show = true;
                                                      pick_icon = Icon(Icons.cancel);
                                                      item != null ? itemController.text = item : itemController.text = null;
                                                    }
                                                    else{
                                                      pick_show = false;
                                                      pick_icon = Icon(Icons.add);
                                                      item != null ? itemController.text = item : itemController.text = null;

                                                    }


                                                  });
                                                },
                                                child: pick_icon),

                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        pick_show == true ? pickupForm() : SizedBox.shrink(),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.directions_bike),
                                            title: Text('Delivery Details'),
                                              trailing: GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      if(delivery_show == false){
                                                        delivery_show = true;
                                                        delivery_icon = Icon(Icons.cancel);
                                                      }
                                                      else{
                                                        delivery_show = false;
                                                        delivery_icon = Icon(Icons.add);
                                                      }
                                                    });


                                                  },
                                                  child: delivery_icon)

                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        delivery_show == true ? deliveryForm() : SizedBox.shrink(),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.note),
                                            title: Text('Note'),
                                            trailing: GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    if(note_show == false){
                                                       note_show = true;
                                                       note_icon = Icon(Icons.cancel);
                                                    }
                                                    else{
                                                      note_show = false;
                                                      note_icon = Icon(Icons.add);
                                                    }
                                                  });


                                                },
                                                child: note_icon),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        note_show == true ? noteForm() : SizedBox.shrink(),
                                        SizedBox(height: 10.0),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.directions_bike),
                                            title: Text('Pick a rider'),
                                            trailing: GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    if(rider_show == false){
                                                      rider_show = true;
                                                      rider_icon = Icon(Icons.cancel);
                                                    }
                                                    else{
                                                      rider_show = false;
                                                      rider_icon = Icon(Icons.add);
                                                    }
                                                  });


                                                },
                                                child: rider_icon),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        rider_show == true ? riderForm() : SizedBox.shrink(),
                                        SizedBox(height: 16.0),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),

                              ],
                            ),
                          ) :
                             _orders == null ? Platform.isIOS ? Center(child: CupertinoActivityIndicator ()) :
                             Center(child: CircularProgressIndicator()) :
                             ListView.builder(
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
                                      child: text('No order history'),
                                    );
                                  }

                                }
                            ),


                        ],
                      )) : Platform.isIOS ? Center(child: CupertinoActivityIndicator ()) :
                  Center(child: CircularProgressIndicator()),

                ],
              ),
            ),
          ),
          SafeArea(
            child: Container(
              color: t1_white,
              padding: EdgeInsets.only(left: 14),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_)=>T1SideMenu(),
                        ));
                      },
                      child: SvgPicture.asset(t1_menu, width: 25, height: 25)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Center(
                      child: headerText('Pick Delivery'),
                    ),
                  )
                ],
              ),
            ),
          ),
          user.type == "Customer" ?
          Positioned(
            bottom: 15.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 5.0),
                        blurRadius: 15.0,
                        spreadRadius: 3
                    )
                  ]

              ),
              child:
              Material(
                  elevation: 2,
                  shadowColor: t1_colorPrimary,
                  borderRadius: new BorderRadius.circular(40.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: MaterialButton(
                        child: text("Proceed", fontSize: textSizeLargeMedium, textColor: t1_white, fontFamily: fontMedium),
                        textColor: t1_white,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
                        color: t1_colorPrimary, onPressed:_submit
                    ),
                  )),
            ),
          ) : SizedBox.shrink(),

        ],
      ),
    );

  }

  Widget tabItem(var pos, var icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = pos;
        });
      },
      child: Container(
        width: 45,
        height: 45,
        alignment: Alignment.center,
        decoration: isSelected == pos ? BoxDecoration(shape: BoxShape.circle, color: t1_colorPrimary_light) : BoxDecoration(),
        child: SvgPicture.asset(
          icon,
          width: 20,
          height: 20,
          color: isSelected == pos ? t1_colorPrimary : t1_textColorSecondary,
        ),
      ),
    );
  }

  Widget mediaButton(String buttonText, String icon) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: t1_color_primary_light),
          width: width / 5.5,
          height: width / 5.5,
          padding: EdgeInsets.all(width / 18),
          child: SvgPicture.asset(
            icon,
            color: t1_colorPrimary,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        text(buttonText, textColor: t1TextColorPrimary, fontSize: textSizeMedium, fontFamily: fontMedium)
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  bool _savePickForm()
  {
    if(!_pickFormKey.currentState.validate())
    {
      return false;

    }
    else{
      _pickFormKey.currentState.save();
      Provider.of<UserData>(context, listen: false).pickItem = item;
      return true;

    }
  }

  bool _saveDeliveryForm()
  {
    if(!_deliveryFormKey.currentState.validate())
    {
      return false;

    }
    else{
      _deliveryFormKey.currentState.save();
      _noteFormKey.currentState.save();
      Provider.of<UserData>(context, listen: false).deliveryName = delivery_name;
      Provider.of<UserData>(context, listen: false).deliveryEmail = delivery_email;
      Provider.of<UserData>(context, listen: false).deliveryPhone = delivery_phone;
      Provider.of<UserData>(context,listen: false).note = note;
      return true;

    }
  }
}

class Slider extends StatelessWidget {
  final String file;

  Slider({Key key, @required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 0,
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Image.asset(file, fit: BoxFit.fill),
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
                      builder: (_)=>OrderDetail(orders: model)
                    ));
                  },
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          text(model.item, fontSize: textSizeMedium, maxLine: 2, textColor: t1TextColorPrimary),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 25),
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
