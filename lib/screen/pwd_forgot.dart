import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_delivery/screen/T1Login.dart';
import 'package:pick_delivery/screen/T1Signup.dart';
import 'package:pick_delivery/services/auth_service.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';

class PwdReset extends StatefulWidget
{
  @override
  _PwdResetState createState() => _PwdResetState();
}

class _PwdResetState extends State<PwdReset>
{

  final _resetFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  var email;

  _submit() async
  {


    if(!_resetFormKey.currentState.validate())
    {
      SizedBox.shrink();
    }

    else if(_isLoading == false)
    {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 1),
            content:
            new Row(
              children: <Widget>[
                Platform.isIOS ? CupertinoActivityIndicator() : new CircularProgressIndicator(),
                new Text("please wait...")
              ],
            ),
          ));



    }
    final authService = Provider.of<AuthService>(context, listen: false);


    try
    {
      if(_resetFormKey.currentState.validate())
      {
        _resetFormKey.currentState.save();

        await authService.sendPasswordReset(email);
        _showErrorDialog("password reset link has been sent to your mail", "success");


      }
    }
    on PlatformException catch(error){
      _showErrorDialog(error.message, "error");
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
              Platform.isIOS ? CupertinoButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.pop(context),
              ) : FlatButton(
                  child: Text('Ok'),
                  onPressed: (){
                    Navigator.pop(context);

                  }
              )
            ],
          );
        }
    );

  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                Image.asset('images/theme1/logo.png', height: 100, width: 100),
                SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[formHeading('Password reset/'),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_)=>T1Login()
                        ));
                      },
                      child: formSubHeadingForm('Sign In'))]),
                SizedBox(height: 50),
                Form(
                  key: _resetFormKey,
                    child: Padding(
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
                ),

                SizedBox(height: 8),

                SizedBox(height: 8),
                Padding(padding: EdgeInsets.fromLTRB(40, 16, 40, 16),
                    child:MaterialButton(
                        child: text("Submit", fontSize: textSizeLargeMedium, textColor: t1_white, fontFamily: fontMedium),
                        textColor: t1_white,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
                        color: t1_colorPrimary, onPressed: _submit
                    )
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
