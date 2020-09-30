import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_delivery/model/user_data.dart';
import 'package:pick_delivery/screen/T1Login.dart';
import 'package:pick_delivery/services/auth_service.dart';
import 'package:pick_delivery/services/database.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class T1Signup extends StatefulWidget {
  @override
  _T1Signup createState() => _T1Signup();
}

class _T1Signup extends State<T1Signup>
{

  static var tag = "/T1SignUp";
  bool isChecked2 = false;
  bool _obscureText = true;
  final _signupFormKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String name, email, password, phone, address, charge, user_type;
  bool _isLoading = false;
  int group = 0;

  void _showPass(bool newValue) => setState((){
    isChecked2  = newValue;
    if (isChecked2 ) {
      setState(() {
        _obscureText = false;
      });

    } else {
      setState(() {
        _obscureText = true;
      });
    }
  });

  _showP(){
    return Checkbox(
        value: isChecked2,
        onChanged: _showPass
    );
  }

  _submit() async
  {

    setState(() => _isLoading = false);

    if(!_signupFormKey.currentState.validate()){
      SizedBox.shrink();
    }

    else if(_isLoading == false)
    {
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



    }
    final authService = Provider.of<AuthService>(context, listen: false);
    final dbService = Provider.of<DatabaseService>(context, listen: false);

    try
    {


      if(_signupFormKey.currentState.validate())
      {

        _signupFormKey.currentState.save();
        final bool isValid = EmailValidator.validate(email);
        if(!isValid)
        {
          _showErrorDialog("Email Is Wrong", "Fail");
          return;
        }
        if(phone.length < 11){
          _showErrorDialog("Invalid phone number", "Fail");
          return;
        }
        if(group == 1)
        {
          user_type = "Rider";
        }
        else if(group == 2)
        {
          user_type = "Customer";
          setState(() {
            address = "";
            charge = "";
          });
        }
        else{
          _showErrorDialog("Select user type", "Fail");
          return;
        }


        List res = await dbService.addUser(name, email, password, phone, user_type, address, charge);
        Map<String, dynamic> map;

        for(int i = 0; i < res.length; i++)
        {
          map = res[i];

        }

        if(map['status'] == "Fail")
        {
          _showErrorDialog(map['msg'], map['status']);
        }
        else
        {
          String license = "";
          String wallet = "0";
          String res =  await authService.signUp(name, email, password, phone, user_type, address, charge, license, wallet);


          if(res != null)
          {
            _showErrorDialog("Registration Succesful", "An email verification link has been sent to your mail");
            Provider.of<UserData>(context, listen: false).currentUserId = res;

          }
          else{
            _showErrorDialog("Error On Registration", "Error");
          }


        }


      }
    }
    on PlatformException catch (err) {
      _showErrorDialog(err.message, "Error");
    }



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


  _showErrorDialog2(String errMessage, String status)
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
                onPressed: ()=>Navigator.popAndPushNamed(context, "/homePage"),
              ) : FlatButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.popAndPushNamed(context, "/homePage"),
              )
            ],
          );
        }
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  children: <Widget>[formHeading(t1_lbl_sign_up_header), GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(
                           builder: (_)=>T1Login()
                       ));
                     },
                      child: formSubHeadingForm(t1_lbl_sign_in))],
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left:50.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Radio(
                              value: 1 ,
                              groupValue: group,
                              activeColor: Color.fromRGBO(42, 163, 237, 1) ,
                              onChanged: (T){
                                setState(() {
                                  group = T;
                                });
                              },
                            ),
                            Text("Rider", style: TextStyle(
                              color: t1_colorPrimary
                            ),),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Radio(
                              value: 2 ,
                              groupValue: group,
                              activeColor: Color.fromRGBO(42, 163, 237, 1) ,
                              onChanged: (T){
                                setState(() {
                                  group = T;
                                });
                              },
                            ),
                            Text("Customer", style: TextStyle(
                              color: t1_colorPrimary
                            ),),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 16),
                Form(
                  key: _signupFormKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator:(input)=>
                          input.trim().isEmpty  ? 'Input field is empty' : null,
                          onSaved:(input)=>name = input,
                          style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                          obscureText: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                            hintText: 'name',
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
                            keyboardType: TextInputType.visiblePassword,
                            validator: (input)=>
                            input.trim().isEmpty ? 'password empty' : null,
                            onSaved: (input)=>password = input,
                            style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                              hintText: 'password',
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
                     SizedBox(height: 16.0),
                     group == 1 ? Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                          child: TextFormField(
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
                      ) : SizedBox.shrink(),
                      SizedBox(height: 16.0),
                      group == 1 ? Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator:(input)=>
                            input.trim().isEmpty  ? 'Input field is empty' : null,
                            onSaved:(input)=>charge = input,
                            style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                            obscureText: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                              hintText: 'fee per kilometer',
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
                      ) : SizedBox.shrink(),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left:50.0),
                        child: Row(
                          children: <Widget>[
                            Text("Show Password: ", style: TextStyle(
                                color: t1_colorPrimary
                            ),),
                            _showP()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left:15.0),
                  child: Column(
                    children: <Widget>[
                      text('By proceeding to create your account,'),
                      text('you are agreeing to our'),
                    ],

                    ),
                  ),

                InkWell(
                  child: Text('Terms & Conditions', style: TextStyle(
                    color: t1_blue
                  ),),
                  onTap: ()=>launch("https://monikonnect.com/pizza/privacy.php"),
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
                        child: text("Sign Up", fontSize: textSizeLargeMedium, textColor: t1_white, fontFamily: fontMedium),
                        textColor: t1_white,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
                        color: t1_colorPrimary, onPressed: _submit
                      ),
                    )),

                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    text(t1_lbl_already_have_account, textColor: t1_textColorSecondary, fontSize: textSizeLargeMedium),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_)=>T1Login()
                        ));
                      },
                        child: text(t1_lbl_sign_in, fontFamily: fontMedium, textColor: t1_blue))
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
