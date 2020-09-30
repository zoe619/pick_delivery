
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_delivery/model/user.dart';
import 'package:pick_delivery/model/user_data.dart';
import 'package:pick_delivery/screen/T1Login.dart';
import 'package:pick_delivery/services/database.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Extension.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';

class T1ProfileUpdate extends StatefulWidget
{

  @override
  _T1ProfileUpdateState createState() => _T1ProfileUpdateState();
  User user;
  T1ProfileUpdate({this.user});
}

class _T1ProfileUpdateState extends State<T1ProfileUpdate>
{
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String name, email, phone, fee, address, license, type;

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController feeController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController licenseController = new TextEditingController();
  bool _isLoading = false;
  String userId;

  User user = new User();
  @override
  initState(){
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).currentUserId;
    setState(() {
      user = widget.user;
    });
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone;
    if(user.type == "Rider"){
      feeController.text = user.fee;
      addressController.text = user.address;
      licenseController.text = user.license;
    }



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

    setState(()=> _isLoading = false);
    if(!_formKey.currentState.validate())
    {
      SizedBox.shrink();
    }
    else if(_isLoading == false)
    {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 3),
            content:
            new Row(
              children: <Widget>[
                Platform.isIOS ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
                new Text("please wait...")
              ],
            ),
            action: new SnackBarAction(
                label: 'OK',
                onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
          ));

    }
    try
    {
      if(_formKey.currentState.validate() && !_isLoading)
      {
        _formKey.currentState.save();


        final dbService = Provider.of<DatabaseService>(context, listen: false);
        if(user.type == "Customer"){
          setState(() {
            fee = "0";
            address = "0";
            license = "0";
          });
        }
//        update user info in mysql server database
        List res = await dbService.updateUser(name, email, phone, fee, address, license);
        Map<String, dynamic> map;
        for(int i = 0; i < res.length; i++)
        {
          map = res[i];

        }

        if(map['status'] == "fail")
        {
          _showErrorDialog(map['msg']);
        }
        else
        {

          // update user in firebase
          User user = User(
              id: userId,
              name: name,
              phone: phone,
              fee: fee,
              address: address,
              license: license
          );

          DatabaseService.updateUserFirebase(user);
          _showErrorDialog("Profile Updated");


          setState(() {
            _isLoading = true;
          });

        }

      }

    }
    on PlatformException catch (err) {
      _showErrorDialog(err.message);
    }

  }

  @override
  Widget build(BuildContext context)
  {
    changeStatusColor(Colors.white);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: t1_app_background,
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                Image.asset(t1_ic_ring, height: 100, width: 100),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[formHeading('Profile Update')],
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left:50.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                    ],
                  ),
                ),
                SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[

                      Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                          child: TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            validator:(input)=>
                            input.trim().isEmpty  ? 'Input field is empty' : null,
                            onSaved:(input)=>name = input,
                            style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                            obscureText: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
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
                            controller: emailController,
                            readOnly: true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (input)=>
                            !input.contains('@') ? 'Please enter a valid email' : null,
                            onSaved: (input)=>email = input,
                            style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                            obscureText: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                              hintText: 'john@gmail.com',
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
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator:(input)=>
                            input.trim().isEmpty  ? 'Input field is empty' : null,
                            onSaved:(input)=>phone = input,
                            style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                            obscureText: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                              hintText: 'phone number',
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
                      user.type == "Rider" ? Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: TextFormField(
                                controller: feeController,
                                keyboardType: TextInputType.number,
                                validator:(input)=>
                                input.trim().isEmpty  ? 'Input field is empty' : null,
                                onSaved:(input)=>fee = input,
                                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                                obscureText: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                                  hintText: 'delivery fee',
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
                                controller: addressController,
                                keyboardType: TextInputType.text,
                                validator:(input)=>
                                input.trim().isEmpty  ? 'Input field is empty' : null,
                                onSaved:(input)=>address = input,
                                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                                obscureText: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                                  hintText: 'address',
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
                                controller: licenseController,
                                keyboardType: TextInputType.text,
                                validator:(input)=>
                                input.trim().isEmpty  ? 'Input field is empty' : null,
                                onSaved:(input)=>license = input,
                                style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                                obscureText: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                                  hintText: 'license',
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
                        ],
                      ) : SizedBox.shrink(),

                    ],
                  ),
                ),

                SizedBox(height: 16),
                Padding(padding: const EdgeInsets.fromLTRB(40, 0, 40, 0), child:
                Material(
                    elevation: 2,
                    shadowColor: Colors.deepOrangeAccent[200],
                    borderRadius: new BorderRadius.circular(40.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: MaterialButton(
                          child: text("Submit", fontSize: textSizeLargeMedium, textColor: t1_white, fontFamily: fontMedium),
                          textColor: t1_white,
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
                          color: t1_colorPrimary, onPressed: _submit
                      ),
                    )),

                ),
                SizedBox(height: 24),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
