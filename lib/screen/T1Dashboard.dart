import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pick_delivery/screen/location.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Extension.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';

class T1Dashboard extends StatefulWidget
{
  static var tag = "/T1Dashboard";
  String userId;
  T1Dashboard({this.userId});

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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String item, email, phone, pick, pick_address, delivery_address, delivery_name, delivery_phone, delivery_email;
  bool _isLoading = false;
  bool pick_show = false;
  bool delivery_show = false;

  Icon pick_icon = Icon(Icons.add);
  Icon delivery_icon = Icon(Icons.add);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("inside home: "+widget.userId);
  }

  pickupForm()
  {
    return Form(
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_)=>Map2(),
                  ));
                },
                child: TextFormField(
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
                ),
              )
          ),
          SizedBox(height: 16.0),
          Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator:(input)=>
                input.trim().isEmpty  ? 'Input field is empty' : null,
                onSaved:(input)=>item = input,
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
          Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                validator:(input)=>
                input.trim().isEmpty  ? 'Input field is empty' : null,
                onSaved:(input)=>phone = input,
                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                  hintText: 'Senders phone',
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
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextFormField(
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
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator:(input)=>
                input.trim().isEmpty  ? 'Input field is empty' : null,
                onSaved:(input)=>delivery_name = input,
                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                  hintText: 'Receivers name',
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
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                validator:(input)=>
                input.trim().isEmpty  ? 'Input field is empty' : null,
                onSaved:(input)=>delivery_phone = input,
                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                  hintText: 'Receivers phone',
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
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                validator:(input)=>
                input.trim().isEmpty  ? 'Input field is empty' : null,
                onSaved:(input)=>delivery_phone = input,
                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                  hintText: 'Receivers email',
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
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          text('Create a delivery', textColor: t1TextColorPrimary, fontSize: textSizeNormal, fontFamily: fontBold),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>
                              [
                                Container(
                                  decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.white),
                                  width: width,
                                  height: height,
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
                                                  }
                                                  else{
                                                    pick_show = false;
                                                    pick_icon = Icon(Icons.add);

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
                                          trailing: Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          text(t1_lbl_send_file, textColor: t1TextColorPrimary, fontSize: textSizeNormal, fontFamily: fontBold),
                          SizedBox(height: 16),
                          Container(
                            alignment: Alignment.center,
                            child: Stack(
                              children: <Widget>[
                                Image.asset(t1_ic_home_image, width: width / 2, height: width / 2.7),
                                Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: t1_color_primary_light),
                                  width: width / 3.5,
                                  height: width / 3.5,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: width / 30),
                                  padding: EdgeInsets.all(width / 18),
                                  child: text(t1_lbl_send_files, textColor: t1_colorPrimary, fontSize: textSizeNormal, maxLine: 2),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: height * 0.1,
                  )
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
                  SvgPicture.asset(t1_menu, width: 25, height: 25),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Center(
                      child: headerText(t1_lbl_home),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 60,
                  decoration: BoxDecoration(
                    color: t1_white,
                    boxShadow: [BoxShadow(color: shadow_color, blurRadius: 10, spreadRadius: 2, offset: Offset(0, 3.0))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        tabItem(1, t1_home),
                        tabItem(2, t1_notification),
                        Container(
                          width: 45,
                          height: 45,
                        ),
                        tabItem(3, t1_settings),
                        tabItem(4, t1_user)
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  width: 55,
                  child: FloatingActionButton(
                    backgroundColor: t1_colorPrimary,
                    child: Icon(
                      Icons.mic,
                      color: t1_white,
                    ),
                  ),
                )
              ],
            ),
          )
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

/*
Container(
child: Column(children: <Widget>[
SizedBox(height: 50),
Container(
margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
child: Column(
children: <Widget>[
rowHeading("Media"),
SizedBox(height: 16),
Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: <Widget>[
new Container(
decoration: new BoxDecoration(
color: t1_colorPrimary_light,
shape: BoxShape.circle,
),
child: Icon(
Icons.insert_drive_file,
color: t1_colorPrimary,
size: 40,
),
padding: EdgeInsets.all(25),
),
new Container(
decoration: new BoxDecoration(
color: t1_colorPrimary_light,
shape: BoxShape.circle,
),
child: Icon(Icons.videocam,
color: t1_colorPrimary, size: 40),
padding: EdgeInsets.all(25),
),
new Container(
decoration: new BoxDecoration(
color: t1_colorPrimary_light,
shape: BoxShape.circle,
),
child:
Icon(Icons.image, color: t1_colorPrimary, size: 40),
padding: EdgeInsets.all(25),
),
],
),
//              SizedBox(height: 30),
//              rowHeading("Send Media"),
//              Container(
//                margin: new EdgeInsets.symmetric(horizontal: 16.0),
//                alignment: FractionalOffset.center,
//                child: Stack(
//                  children: <Widget>[
//                    Image.asset(
//                      'img/theme1_ic_home_image.png',
//                      height: 300,
//                      width: 300,
//                    ),
//                  ],
//                ),
//              ),
],
))
]))*/
