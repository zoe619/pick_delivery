//import 'dart:async';
//
//import 'package:geocoder/geocoder.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:uuid/uuid.dart';
//
//class Map2 extends StatefulWidget {
//  @override
//  _MapState createState() => _MapState();
//}
//
//class _MapState extends State<Map2>
//{
//
//  GoogleMapController mapController;
//  static LatLng _initialPosition;
//  LatLng _lastPosition = _initialPosition;
//  final Set<Marker> _markers = {};
//  final Set<Polyline> _polyLines = {};
//
//  TextEditingController locationController = new TextEditingController();
//  TextEditingController destinationController = new TextEditingController();
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _getUserLocation();
//  }
//
//  @override
//  Widget build(BuildContext context)
//  {
//    return MaterialApp(
//        debugShowCheckedModeBanner: false,
//        home: Scaffold(
//          appBar: AppBar(
//            title: Text('pick delivery'),
//            backgroundColor: Theme.of(context).primaryColor,
//
//          ),
//          body: _initialPosition == null ? Container(
//            alignment: Alignment.center,
//            child: Center(
//              child: CircularProgressIndicator(),
//            ),
//          ) : Stack(
//            children: <Widget>[
//              GoogleMap(
//                initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 10.0),
//                onMapCreated: onCreated,
//                myLocationEnabled: true,
//                mapType: MapType.normal,
//                compassEnabled: true,
//                markers: _markers,
//                onCameraMove: _onCameraMove,
//              ),
////        Positioned(
////          top: 40.0,
////          right: 10.0,
////          child: FloatingActionButton(onPressed: _onAddMarkerPressed,
////            tooltip: "add marker",
////            backgroundColor: Colors.black,
////            child: Icon(Icons.add_location, color: Colors.white),
////          ),
////
////        ),
//              Positioned(
//                top: 50.0,
//                right: 15.0,
//                left: 15.0,
//                child: Container(
//                  height: 50.0,
//                  width: double.infinity,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(3.0),
//                      color: Colors.white,
//                      boxShadow: [
//                        BoxShadow(
//                            color: Colors.grey,
//                            offset: Offset(1.0, 5.0),
//                            blurRadius: 15.0,
//                            spreadRadius: 3
//                        )
//                      ]
//
//                  ),
//                  child: TextFormField(
//                    cursorColor: Colors.black,
//                    controller: locationController,
//                    decoration: InputDecoration(
//                        icon: Container(
//                          margin: EdgeInsets.only(left: 20.0, top: 5.0),
//                          width: 10.0,
//                          height: 10.0,
//                          child: Icon(Icons.location_on, color: Colors.black),
//                        ),
//                        hintText: "Pick Up",
//                        border: InputBorder.none,
//                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0)
//                    ),
//                  ),
//                ),
//              ),
//              Positioned(
//                top: 105.0,
//                right: 15.0,
//                left: 15.0,
//                child: Container(
//                  height: 50.0,
//                  width: double.infinity,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(3.0),
//                      color: Colors.white,
//                      boxShadow: [
//                        BoxShadow(
//                            color: Colors.grey,
//                            offset: Offset(1.0, 5.0),
//                            blurRadius: 15.0,
//                            spreadRadius: 3
//                        )
//                      ]
//
//                  ),
//                  child: TextFormField(
//                    cursorColor: Colors.black,
//                    controller: destinationController,
//                    decoration: InputDecoration(
//                        icon: Container(
//                          margin: EdgeInsets.only(left: 20.0, top: 5.0),
//                          width: 10.0,
//                          height: 10.0,
//                          child: Icon(Icons.local_taxi, color: Colors.black),
//                        ),
//                        hintText: "destination?",
//                        border: InputBorder.none,
//                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0)
//                    ),
//                  ),
//                ),
//              )
//            ],
//          ),
//        ));
//  }
//
//  void onCreated(GoogleMapController controller)
//  {
//    setState(() {
//      mapController = controller;
//    });
//  }
//
//  void _onCameraMove(CameraPosition position)
//  {
//    setState(() {
//      _lastPosition = position.target;
//    });
//
//  }
//
//  void _onAddMarkerPressed()
//  {
//    var uuid = new Uuid();
//    setState(() {
//      _markers.add(Marker(markerId: MarkerId(_lastPosition.toString()),
//          position: _lastPosition,
//          infoWindow: InfoWindow(
//              title: "remember me",
//              snippet: "good place"
//          ),
//          icon: BitmapDescriptor.defaultMarker
//      ));
//
//    });
//  }
//
//  List decodePoly(String poly)
//  {
//    var list = poly.codeUnits;
//    var lList = new List();
//    int index = 0;
//    int len = poly.length;
//    int c = 0;
////    repeating until all attributes are decoded
//    do{
//      var shift = 0;
//      int result = 0;
//
////      for decode values of one attribute
//      do{
//        c = list[index] - 63;
//        result |= (c & 0x1F) << (shift*5);
//        index++;
//        shift++;
//      }
//      while(c >= 32);
////        if value is negative then bitwise not the value */
//      if(result & 1 == 1){
//        result =~ result;
//      }
//      var result1 = (result >> 1) * 0.00001;
//      lList.add(result1);
//
//    }
//    while(index < len);
//
////    adding tp previous value as done in encoding
//    for(var i = 2; i < lList.length; i++)
//    {
//      lList[i] += lList[i-2];
//
//    }
//    print(lList.toString());
//    return lList;
//  }
//
//  void _getUserLocation() async
//  {
//    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
////    List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
//    setState(() {
//      _initialPosition = LatLng(position.latitude, position.longitude);
//
//      print(position.latitude);
//      print(position.longitude);
//
//    });
//  }
//}