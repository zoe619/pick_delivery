import 'package:flutter/material.dart';
import 'package:pick_delivery/screen/T1Login.dart';
import 'package:pick_delivery/screen/T1Signup.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';

class PwdReset extends StatefulWidget
{
  @override
  _PwdResetState createState() => _PwdResetState();
}

class _PwdResetState extends State<PwdReset>
{
  var email;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
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
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[formHeading('Password reset/'),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_)=>T1Login()
                        ));
                      },
                      child: formSubHeadingForm('Sign In'))]),
                SizedBox(height: 50),
                editTextStyle('type in your email', TextInputType.emailAddress, email, isPassword: false),

                SizedBox(height: 8),

                SizedBox(height: 8),
//                Padding(padding: EdgeInsets.fromLTRB(40, 16, 40, 16), child: shadowButton('Submit')),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
