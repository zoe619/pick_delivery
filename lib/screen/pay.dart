import 'dart:convert';
import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pick_delivery/model/bank.dart';
import 'package:pick_delivery/model/user.dart';
import 'package:pick_delivery/model/user_data.dart';
import 'package:pick_delivery/screen/T1Dashboard.dart';
import 'package:pick_delivery/screen/T1Listing.dart';
import 'package:pick_delivery/screen/T1Sidemenu.dart';
import 'package:pick_delivery/screen/location.dart';
import 'package:pick_delivery/screen/orders.dart';
import 'package:pick_delivery/screen/pay2.dart';
import 'package:pick_delivery/screen/riders.dart';
import 'package:pick_delivery/services/database.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Extension.dart';
import 'package:pick_delivery/utils/T1Images.dart';
import 'package:pick_delivery/utils/T1Strings.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class Pay extends StatefulWidget
{


  String item, deliveryName, deliveryPhone, deliveryEmail, note;
  Pay({this.item, this.deliveryName, this.deliveryPhone, this.deliveryEmail, this.note});

  @override
  State<StatefulWidget> createState() {
    return PayState();
  }
}

class PayState extends State<Pay>
{

  String backendUrl = 'https://api.paystack.co/transaction';
  String paystackSecretKey = 'sk_live_a9a87b7497c6a00f9b472e77198c5774a6378394';
  String paystackPublicKey = 'pk_live_140823c0754222c801446bd1b1b878f408f3b35a';

  var isSelected = 1;
  var width;
  var height;
  final _pickFormKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();


  String item, email, phone, pick, pickAddress, deliveryAddress, deliveryName, deliveryPhone,
      deliveryEmail, note, rider;
  bool _isLoading = false;
  bool bill_show = false;
  bool delivery_show = false;
  bool pick_show = false;
  bool rider_show = false;
  bool wall_show = false;
  bool bank_show = false;
  Color change = Colors.white;
  Color change2 = Colors.white;


  double distance, amount;



  TextEditingController pickController = new TextEditingController();
  TextEditingController destinationController = new TextEditingController();
  TextEditingController itemController = new TextEditingController();
  TextEditingController pickPhoneController = new TextEditingController();
  TextEditingController riderController = new TextEditingController();

  String userId;
  Users user = new Users();

  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;
  String payMethod;
  String payText = "Make Payment";
  String senderEmail, riderName, riderEmail, riderPhone;

  double pickLatitude, pickLongitude, destinationLatitude, destinationLongitude;
  bool _isLocal = true;
  int price;
  String _reference;
  String _wallet;
  String _accountName, _accountNumber, _bank;
  String _userId, _riderId;

  String d;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PaystackPlugin.initialize(publicKey: paystackPublicKey);
    userId = Provider.of<UserData>(context, listen: false).currentUserId;
    change = Colors.white;
    _setupProfileUser();
    _getBank();


  }

  _getBank()async
  {
    List<Bank> bank = await Provider.of<DatabaseService>(context,listen: false).getBank();
    Bank b = bank[0];
    setState(() {
      _bank = b.bank;
      _accountName = b.accountName;
      _accountNumber = b.accountNumber;
    });
  }



  _setupProfileUser() async
  {
    Users profileUser  = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(userId);
    setState(() {
      user = profileUser;
      senderEmail = user.email;
      _wallet = user.wallet;

      pickLatitude = Provider.of<UserData>(context, listen: false).pickLatitude;
      pickLongitude = Provider.of<UserData>(context, listen: false).pickLongitude;
      destinationLatitude = Provider.of<UserData>(context, listen: false).deliveryLatitude;
      destinationLongitude = Provider.of<UserData>(context,listen: false).deliveryLongitude;
      pickAddress = Provider.of<UserData>(context, listen: false).pickAddress;
      deliveryAddress = Provider.of<UserData>(context, listen: false).deliveryAddress;
      d = Provider.of<UserData>(context, listen: false).deliveryName;

      riderName = Provider.of<UserData>(context, listen: false).riderName;
      riderEmail = Provider.of<UserData>(context, listen: false).riderEmail;
      riderPhone = Provider.of<UserData>(context, listen: false).riderPhone;

      distance = Provider.of<UserData>(context, listen: false).distance;
      distance = distance / 1000;
      String am = Provider.of<UserData>(context, listen: false).amount;
      double m = double.parse(am);
      amount = m * distance;
      price = amount.round();

        widget.deliveryName = Provider.of<UserData>(context, listen: false).deliveryName;
        widget.deliveryEmail = Provider.of<UserData>(context, listen: false).deliveryEmail;
        widget.deliveryPhone = Provider.of<UserData>(context, listen: false).deliveryPhone;
        widget.item = Provider.of<UserData>(context, listen: false).pickItem;
        widget.note = Provider.of<UserData>(context, listen: false).note;



    });
  }

  _dispose()
  {
    Provider.of<UserData>(context, listen: false).pickLatitude = null;
    Provider.of<UserData>(context, listen: false).pickLongitude = null;
    Provider.of<UserData>(context, listen: false).deliveryLatitude = null;
    Provider.of<UserData>(context,listen: false).deliveryLongitude = null;
    Provider.of<UserData>(context, listen: false).pickAddress = null;
    Provider.of<UserData>(context, listen: false).deliveryAddress = null;
    Provider.of<UserData>(context, listen: false).riderName = null;
    Provider.of<UserData>(context, listen: false).riderEmail = null;
    Provider.of<UserData>(context, listen: false).riderPhone = null;
    Provider.of<UserData>(context, listen: false).deliveryName = null;
    Provider.of<UserData>(context, listen: false).deliveryEmail = null;
    Provider.of<UserData>(context, listen: false).deliveryPhone = null;
    Provider.of<UserData>(context, listen: false).pickItem = null;
    Provider.of<UserData>(context, listen: false).note = null;

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
              FlatButton(
                  child: Text('Ok'),
                  onPressed: (){

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => T1Dashboard()),
                      ModalRoute.withName('/'),
                    );


                  }
              ),
            ],
          );
        }
    );

  }

  _walletPay() async
  {

    final dbService = Provider.of<DatabaseService>(context, listen: false);

    int p = price + 50;
    if(p > int.parse(_wallet))
    {
      _showErrorDialog("Insufficient wallet balance", "Error");
      return;
    }
    if(_isLoading == false)
    {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 2),
            content:
            new Row(
              children: <Widget>[
                Platform.isIOS ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
                new Text("please wait...")
              ],
            ),
            action: new SnackBarAction(
                label: 'Ok',
                onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
          ));

    }
    try
    {

      String payStatus = "Paid";

      List res = await dbService.addDelivery(
          senderEmail, pickAddress, distance, amount, pickLatitude, pickLongitude,
          destinationLatitude, destinationLongitude, widget.deliveryName, widget.deliveryEmail, widget.deliveryPhone,
          deliveryAddress, widget.note, riderName, riderEmail, riderPhone, payMethod, payStatus, widget.item
      );

      Map<String, dynamic> map;

      for(int i = 0; i < res.length; i++)
      {
        map = res[i];
        setState(() {
          _isLoading = true;
        });

      }
      if(map['status'] == "Fail")
      {
        _showErrorDialog(map['msg'], map['status']);

      }
      else
      {

        String type = "sub";
        double amount = price.ceilToDouble() + 50;

        List res = await Provider.of<DatabaseService>(context, listen: false).wallet(senderEmail, type, amount);

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
        else {
          // update user in firebase
          price = price + 50;
          int prices = int.parse(_wallet) - price;
          prices = prices.abs();
          Users user = Users(
            id: userId,
            wallet: prices.toString(),
          );

          DatabaseService.updateWallet(user);
          DatabaseService.sendId(Provider.of<UserData>(context,listen: false).riderId);
          _dispose();
          _showErrorDialog("Delivery Request Submitted. You can monitor your request status on the request history screen of the app", map['status']);
        }

      }



    }on PlatformException catch(error)
    {
      _showErrorDialog(error.message, "Error");
    }
  }
  _deliveryPay() async
  {

    final dbService = Provider.of<DatabaseService>(context, listen: false);
    if(_isLoading == false)
    {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 2),
            content:
            new Row(
              children: <Widget>[
                Platform.isIOS ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
                new Text("please wait...")
              ],
            ),
            action: new SnackBarAction(
                label: 'Ok',
                onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
          ));

    }
    try
    {

      String payStatus = "Not paid";



      List res = await dbService.addDelivery(
          senderEmail, pickAddress, distance, amount, pickLatitude, pickLongitude,
          destinationLatitude, destinationLongitude, widget.deliveryName, widget.deliveryEmail, widget.deliveryPhone,
          deliveryAddress, widget.note, riderName, riderEmail, riderPhone, payMethod, payStatus, widget.item
      );

      Map<String, dynamic> map;

      for(int i = 0; i < res.length; i++)
      {
        map = res[i];
        setState(() {
          _isLoading = true;
        });

      }
      if(map['status'] == "Fail")
      {
        _showErrorDialog(map['msg'], map['status']);

      }
      else
      {
        _dispose();
        _showErrorDialog(map['msg'], map['status']);
        DatabaseService.sendId(Provider.of<UserData>(context,listen: false).riderId);

      }



    }on PlatformException catch(error)
    {
      _showErrorDialog(error.message, "Error");
    }
  }

  _transferPay() async
  {

    final dbService = Provider.of<DatabaseService>(context, listen: false);
    if(_isLoading == false)
    {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 2),
            content:
            new Row(
              children: <Widget>[
                Platform.isIOS ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
                new Text("please wait...")
              ],
            ),
            action: new SnackBarAction(
                label: 'Ok',
                onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
          ));

    }
    try
    {

      String payStatus = "Not paid";

      List res = await dbService.addDelivery(
          senderEmail, pickAddress, distance, amount, pickLatitude, pickLongitude,
          destinationLatitude, destinationLongitude, widget.deliveryName, widget.deliveryEmail, widget.deliveryPhone,
          deliveryAddress, widget.note, riderName, riderEmail, riderPhone, payMethod, payStatus, widget.item
      );

      Map<String, dynamic> map;

      for(int i = 0; i < res.length; i++)
      {
        map = res[i];
        setState(() {
          _isLoading = true;
        });

      }
      if(map['status'] == "Fail")
      {
        _showErrorDialog(map['msg'], map['status']);

      }
      else
      {
        DatabaseService.sendId(Provider.of<UserData>(context,listen: false).riderId);
        _dispose();
        _showErrorDialog(map['msg'], map['status']);

      }



    }on PlatformException catch(error)
    {
      _showErrorDialog(error.message, "Error");
    }
  }
  _startAfreshCharge() async
  {
    if(payMethod == "pick")
    {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 15),
            content:
            new Row(
              children: <Widget>[
                Platform.isIOS ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
                new Text("processing...")
              ],
            ),
            action: new SnackBarAction(
                label: 'Ok',
                onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
          ));

      Charge charge = Charge();
      charge.card = _getCardFromUI();

      setState(() => _inProgress = true);


      if (_isLocal) {
        // Set transaction params directly in app (note that these params
        // are only used if an access_code is not set. In debug mode,
        // setting them after setting an access code would throw an exception

        charge
          ..amount = price * 100 // In base currency
          ..email = senderEmail
          ..reference = _getReference()
          ..putCustomField('Charged From', 'Pick Delivery');
        _chargeCard(charge);
      } else {
        // Perform transaction/initialize on Paystack server to get an access code
        // documentation: https://developers.paystack.co/reference#initialize-a-transaction
        charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
        _chargeCard(charge);
      }
    }
    else if(payMethod == "delivery"){
      _deliveryPay();
    }
    else if(payMethod == "wallet"){
      _walletPay();
    }
    else if(payMethod == "transfer"){
      _transferPay();
    }
  }

  _chargeCard(Charge charge)
  {
    // This is called only before requesting OTP
    // Save reference so you may send to server if error occurs with OTP
    handleBeforeValidate(Transaction transaction)
    {
//      _updateStatus(transaction.reference, 'validating...');
      setState(() {
        _reference = transaction.reference;
      });

    }

    handleOnError(Object e, Transaction transaction)
    {
      // If an access code has expired, simply ask your server for a new one
      // and restart the charge instead of displaying error
      if (e is ExpiredAccessCodeException)
      {
        _startAfreshCharge();
        _chargeCard(charge);
        return;
      }
      else if (e is AuthenticationException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog(e.message, "Failed");


        return;
      }
      else if (e is InvalidAmountException)
      {
        setState(() => _inProgress = false);

        _showErrorDialog(e.message, "Failed");

        return;
      }
      else if (e is InvalidEmailException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog(e.message, "Failed");

        return;
      }
      else if (e is CardException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog(e.message, "Failed");

        return;
      }
      else if (e is ChargeException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog(e.message, "Failed");

        return;

      }
      else if (e is PaystackException)
      {
        setState(() => _inProgress = false);
        return;

      }
      else if (e is PaystackSdkNotInitializedException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog(e.message, "Failed");
        return;

      }
      else if(e is ProcessException)
      {

        setState(() => _inProgress = false);
        _showErrorDialog(e.message, "Failed");
        return;

      }

      if(transaction.reference != null)
      {
        _verifyOnServer(transaction.reference);
//        _showErrorDialog("verifying transaction on server", "failed");
        return;

      }
      else
      {
        setState(() => _inProgress = false);
//        _updateStatus(transaction.reference, e.toString());
      }
    }


    // This is called only after transaction is successful
    handleOnSuccess(Transaction transaction) async
    {



      bool response;
      if(_isLocal){
        response = true;
      }
      else{
        response = await _verifyOnServer(transaction.reference);
      }
      if(response)
      {

        try
        {

          String payStatus = "Paid";
          List res = await Provider.of<DatabaseService>(context, listen: false).addDelivery(
              senderEmail, pickAddress, distance, amount, pickLatitude, pickLongitude,
              destinationLatitude, destinationLongitude, widget.deliveryName, widget.deliveryEmail, widget.deliveryPhone,
              deliveryAddress, widget.note, riderName, riderEmail, riderPhone, payMethod, payStatus, widget.item
          );

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
            DatabaseService.sendId(Provider.of<UserData>(context,listen: false).riderId);
            _dispose();
            _showErrorDialog(map['msg'], map['status']);

          }



        }on PlatformException catch(error)
        {
          _showErrorDialog(error.message, "Error");
        }

      }
    }



    PaystackPlugin.chargeCard(context,
      charge: charge,
      beforeValidate: (transaction) => handleBeforeValidate(transaction),
      onSuccess: (transaction) => handleOnSuccess(transaction),
      onError: (error, transaction) => handleOnError(error, transaction),
    );
  }

  String _getReference()
  {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  Future<String> _fetchAccessCodeFrmServer(String reference) async
  {
    int amounts = price * 100;
    var map = Map<String, dynamic>();
    map['email'] = senderEmail;
    map['amount'] = amounts.toString();
    String url = 'https://jahmbatsonlogistics.com/new_mobile/pizza/initialize.php';
    String accessCode;
    try
    {

      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      List result = json.decode(response.body);

      Map<String, dynamic> maps;

      for(int i = 0; i < result.length; i++)
      {
        maps = result[i];

      }
      accessCode = maps['code'];
      print(accessCode);


    } catch (e) {
      setState(() => _inProgress = false);
      _updateStatus(
          reference,
          'There was a problem getting access code');
    }

    return accessCode;
  }

  Future<bool> _verifyOnServer(String reference) async
  {
    bool rep;
    var map = Map<String, dynamic>();
    map['reference'] = reference;
    _updateStatus(reference, 'Verifying...');
    String url = 'https://jahmbatsonlogistics.com/new_mobile/pizza/verify.php';
    List result;
    try
    {
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      result = json.decode(response.body);
      print(result);
      Map<String, dynamic> maps;

      for(int i = 0; i < result.length; i++)
      {
        maps = result[i];

      }
      if(maps['status'] == "success")
      {
        rep = true;
      }



    }
    catch(e)
    {
      _updateStatus(
          reference,
          'There was a problem verifying your transaction on the server:');

      rep = false;
    }
    setState(() => _inProgress = false);
    return rep;
  }

  _updateStatus(String reference, String message)
  {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'close',
          onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
    ));
  }


  billForm(){
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Subtotal'),
                Text('NGN $price')
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total'),
                Text('NGN ${price + 50}')
              ],
            ),
          ],
        )
    );
  }

  _walletForm()
  {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Wallet balance'),
                Text('NGN $_wallet')
              ],
            ),
          ],
        )
    );
  }


  _bankForm()
  {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Bank Name'),
                Text('$_bank')
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Account Name'),
                Text('$_accountName', maxLines: 2, style: TextStyle(
                  fontSize: 10.0
                ),)
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Account Number'),
                Text('$_accountNumber')
              ],
            ),
          ],
        )
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
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(Icons.account_balance_wallet),
                                              title: Text('Wallet Balance'),

                                            ),
                                          ),

                                          onTap: (){
                                            setState(() {
                                              if(wall_show == false)
                                              {
                                                wall_show = true;


                                              }
                                              else{
                                                wall_show = false;



                                              }


                                            });
                                          },
                                        ),
                                        SizedBox(height: 5.0),
                                        wall_show == true ? _walletForm() : SizedBox.shrink(),
                                        SizedBox(height: 10.0),
                                        GestureDetector(
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(Icons.note),
                                              title: Text('Bill Summary'),

                                            ),
                                          ),

                                          onTap: (){
                                            setState(() {
                                              if(bill_show == false)
                                              {
                                                bill_show = true;

                                              }
                                              else{
                                                bill_show = false;


                                              }


                                            });
                                          },
                                        ),
                                        SizedBox(height: 5.0),
                                        bill_show == true ? billForm() : SizedBox.shrink(),
                                        SizedBox(height: 10.0),
                                        text('Select a payment option below', textColor: t1TextColorPrimary, fontSize: textSizeLargeMedium, fontFamily: fontMedium),
                                        SizedBox(height: 5.0),
                                        Column(
                                          children: <Widget>[
                                             Container(
                                              decoration: BoxDecoration(
                                              color: change2
                                              ),
                                               child: GestureDetector(
                                                child: Card(
                                                  child: ListTile(
                                                    leading: Icon(Icons.account_balance_wallet),
                                                    title: Text('Pay from wallet'),

                                                  ),
                                                ),
                                                onTap: (){
                                                  setState(() {
                                                    if(wall_show == false)
                                                    {
                                                      change2 = t1_colorPrimary;
                                                      payMethod = "wallet";
                                                      payText = "Make Payment";
                                                      pick_show = false;
                                                      delivery_show = false;
                                                      bank_show = false;
                                                      change = Colors.white;

                                                    }
                                                    else{
                                                      change2 = t1_colorPrimary;
                                                      change = Colors.white;
                                                      payMethod = "wallet";
                                                      payText = "Make Payment";
                                                      pick_show = false;
                                                      delivery_show = false;
                                                      bank_show = false;

                                                    }


                                                  });
                                                },
                                            ),
                                             ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: change
                                              ),
                                              child: GestureDetector(
                                                child: Card(
                                                  child: ListTile(
                                                    leading: Icon(Icons.money_off),
                                                    title: Text('Cash on delivery'),

                                                  ),
                                                ),
                                                onTap: (){
                                                  setState(() {
                                                    if(delivery_show == false)
                                                    {
                                                      delivery_show = true;
                                                      change = t1_colorPrimary;
                                                      payMethod = "delivery";
                                                      payText = "Submit";
                                                      pick_show = false;
                                                      bank_show = false;
                                                      change2 = Colors.white;

                                                    }
                                                    else{
                                                      delivery_show = false;
                                                      change = t1_colorPrimary;
                                                      payMethod = "delivery";
                                                      payText = "Submit";
                                                      pick_show = false;
                                                      bank_show = false;
                                                      change2 = Colors.white;

                                                    }


                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            GestureDetector(
                                              child: Card(
                                                child: ListTile(
                                                  leading: Icon(Icons.cast_connected),
                                                  title: Text('Bank Transfer'),

                                                ),
                                              ),
                                              onTap: (){
                                                setState(() {
                                                  if(bank_show == false)
                                                  {
                                                    bank_show = true;
                                                    payMethod = "transfer";
                                                    payText = "Submit";
                                                    pick_show = false;
                                                    wall_show = false;
                                                    delivery_show = false;
                                                    change2 = Colors.white;
                                                    change = Colors.white;

                                                  }
                                                  else{
                                                    bank_show = false;
                                                    payMethod = "transfer";
                                                    payText = "Submit";
                                                    pick_show = false;
                                                    wall_show = false;
                                                    delivery_show = false;
                                                    change2 = Colors.white;
                                                    change = Colors.white;

                                                  }


                                                });
                                              },
                                            ),
                                            SizedBox(height: 5.0),
                                            bank_show == true ? _bankForm() : SizedBox.shrink(),
                                          ],
                                        ),
                                        SizedBox(height: 5.0),
                                        GestureDetector(
                                          child: Card(
                                            child: ListTile(
                                              leading: Icon(Icons.monetization_on),
                                              title: Text('Cash on pick-up'),

                                            ),
                                          ),
                                          onTap: (){
                                            setState(() {
                                              if(pick_show == false)
                                              {
                                                pick_show = true;
                                                change = Colors.white;
                                                change2 = Colors.white;
                                                payMethod = "pick";
                                                payText = "Make Payment";
                                                bank_show = false;

                                              }
                                              else{
                                                pick_show = false;
                                                bank_show = false;
                                                payMethod = 'pick';
                                                change = Colors.white;
                                                change2 = Colors.white;
                                                payText = "Make Payment";

                                              }


                                            });
                                          },
                                        ),
                                        SizedBox(height: 5.0),
                                        pick_show == true ? _buildCard() : SizedBox.shrink(),

                                        SizedBox(height: 22.0),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                              ],
                            ),
                          ),

                        ],
                      )),

                ],
              ),
            ),
          ),
          TopBar('Pick payment'),
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
              child:Material(
                  elevation: 2,
                  shadowColor: Colors.deepOrangeAccent[200],
                  borderRadius: new BorderRadius.circular(40.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: MaterialButton(
                        child: text(payText, fontSize: textSizeLargeMedium, textColor: t1_white, fontFamily: fontMedium),
                        textColor: t1_white,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
                        color: t1_colorPrimary, onPressed:_startAfreshCharge
                    ),
                  )),
            ),
          ),

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

  Widget _buildCard()
  {

    return Container(
      child: Column(
        children: <Widget>[
          new TextFormField(
            decoration: const InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: 'Card Number',
            ),
            onSaved: (String value) => _cardNumber = value,
          ),
          SizedBox(height: 10.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'CVV',
                  ),
                  onSaved: (String value) => _cvv = value,
                ),
              ),
              SizedBox(height: 10.0),
              new Expanded(
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Expiry Month',
                  ),
                  onSaved: (String value) =>
                  _expiryMonth = int.tryParse(value),
                ),
              ),
              SizedBox(height: 10.0),
              new Expanded(
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Expiry Year',
                  ),
                  onSaved: (String value) =>
                  _expiryYear = int.tryParse(value),
                ),
              )
            ],
          ),
        ],
      ),

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
