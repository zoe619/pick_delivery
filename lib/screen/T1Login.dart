import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_delivery/model/user_data.dart';
import 'package:pick_delivery/screen/T1Dashboard.dart';
import 'package:pick_delivery/screen/T1Signup.dart';
import 'package:pick_delivery/screen/pwd_forgot.dart';
import 'package:pick_delivery/services/auth_service.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';

class T1Login extends StatefulWidget {
  static var tag = "/T1SignIn";

  @override
  _T1LoginState createState() => _T1LoginState();
}

class _T1LoginState extends State<T1Login>
{
  final _loginFormKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool rememberMe = false;
  bool isChecked2 = false;
  bool _obscureText = true;
  var email, password;
  bool _isLoading = false;
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

    if(!_loginFormKey.currentState.validate()){
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


    try
    {


      if(_loginFormKey.currentState.validate())
      {

        _loginFormKey.currentState.save();

        String login = await authService.login(email, password);
        Provider.of<UserData>(context, listen: false).currentUserId = login;




        if(login != "")
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>T1Dashboard(),
          ));
        }
        else{
          _showErrorDialog("Please check your email to verify your account", "error");
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
                Image.asset(t1_ic_ring, height: 100, width: 100),
                SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[formHeading(t1_lbl_sign_in_header),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_)=>T1Signup()
                      ));
                    },
                      child: formSubHeadingForm(t1_lbl_sign_up))]),
                SizedBox(height: 50),

                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: <Widget>[
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: CheckboxListTile(
                    title: text('show password', textColor: t1TextColorPrimary),
                    value: rememberMe,
                    onChanged: (newValue)
                    {
                      rememberMe = newValue;
                      if (rememberMe) {
                        setState(() {
                          _obscureText = false;
                        });

                      } else {
                        setState(() {
                          _obscureText = true;
                        });
                      }

                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                SizedBox(height: 8),
                Padding(padding: const EdgeInsets.fromLTRB(40, 0, 40, 0), child:
                Material(
                    elevation: 2,
                    shadowColor: Colors.deepOrangeAccent[200],
                    borderRadius: new BorderRadius.circular(40.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: MaterialButton(
                          child: text("Sign In", fontSize: textSizeLargeMedium, textColor: t1_white, fontFamily: fontMedium),
                          textColor: t1_white,
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
                          color: t1_colorPrimary, onPressed: _submit
                      ),
                    )),

                ),
                SizedBox(height: 24),
                GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_)=>PwdReset()
                        ));

                    },
                    child: text(t1_lbl_forgot_password, textColor: t1_textColorPrimary, fontFamily: fontMedium))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
