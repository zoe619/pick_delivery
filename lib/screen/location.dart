import 'dart:async';
import 'dart:collection';

import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class Map2 extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map2>
{

  GoogleMapController mapController;
  static LatLng _initialPosition;
  static LatLng _lastPosition = _initialPosition;
  Position _lastVisitedPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  Position _position;
  StreamSubscription<Position> _streamSubscription;
  Address _address;
  TextEditingController locationController = new TextEditingController();
  TextEditingController destinationController = new TextEditingController();
  MapType _currentMapType = MapType.normal;
  Set<Marker> allMarkers = {};
  BitmapDescriptor _markerIcon;

  var finalAddress;

  Set<Marker> _markers2 = HashSet<Marker>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserLocation();


  }



  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Center(child: Text('Pick delivery')),
            backgroundColor: Theme.of(context).primaryColor,

          ),
          body: _initialPosition == null ? Container(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) :

          Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 10.0),
          onMapCreated: onCreated,
          myLocationEnabled: true,
          mapType: MapType.normal,
          compassEnabled: true,
          markers: _markers,
          onCameraMove: _onCameraMove,
          onCameraIdle: _onCameraIdle,
          zoomControlsEnabled: true,
          onTap: (coordinates)
          {
            mapController.animateCamera(CameraUpdate.newLatLng(coordinates));
            _addMarker(coordinates);
            _getAddress(coordinates);

          },
        ),
        Positioned(
          top: 100.0,
          right: 10.0,
          child: FloatingActionButton(onPressed: _gotoPosition1,
            tooltip: "location",
            backgroundColor: Colors.blue,
            child: Icon(Icons.location_searching, color: Colors.white),
          ),

        ),
        Positioned(
          top: 15.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 5.0),
                      blurRadius: 15.0,
                      spreadRadius: 3
                  )
                ]

            ),
            child: Flexible(
              child: TextField(
                maxLines: 3,
                cursorColor: Colors.black,
                controller: locationController,
                decoration: InputDecoration(
                    icon: Container(
                      margin: EdgeInsets.only(left: 8.0, bottom: 10.0),
                      width: 10.0,
                      height: 10.0,
                      child: Icon(Icons.location_on, color: Colors.red),
                    ),
                    hintText: "Pick up location",
                    border: InputBorder.none,

                    contentPadding: EdgeInsets.only(left: 15.0, top: 16.0)
                ),
              ),
            ),
          ),
        ),
//        button(_onMapTypePressed, Icons.map),
//        SizedBox(height: 16.0),
//        button(_onAddMarkerPressed, Icons.add_location),
//        SizedBox(height: 16.0),
//        button(_gotoPosition1, Icons.location_searching)
      ],
    ),
   ));
  }


  void onCreated(GoogleMapController controller)
  {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position)
  {
    setState(() {
      _lastPosition = position.target;

    });

  }
  _onCameraIdle(){
    setState(() {
      _lastPosition = _lastPosition;
      _getAddress(_lastPosition);
    });
  }
  _onMapTypePressed(){
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }
  static final CameraPosition _position1 = CameraPosition(
      bearing: 192.833,
      target: _lastPosition,
      tilt: 59.440,
      zoom: 11.0

  );

  Future<void> _gotoPosition1()async
  {
//    final GoogleMapController controller = await mapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(_position1));
    _getAddress(_lastPosition);


  }
  Widget button(Function function, IconData icon){
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(icon, size: 36.0),
    );
  }

  _addMarker(coordinates)
  {
    Uuid id = Uuid();
    setState(() {
      _markers.add(Marker(
        position: coordinates,
        markerId: MarkerId(id.toString()),
      ));
    });

  }




  void _getUserLocation() async
  {


    bool isLocationServiceEnable  = await isLocationServiceEnabled();
    _lastVisitedPosition = await getLastKnownPosition();
    if(isLocationServiceEnable){
      Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        if(_initialPosition == null) {
          _initialPosition = LatLng(_lastVisitedPosition.latitude, _lastVisitedPosition.longitude);
        }
      });
      _getAddress(_initialPosition);

    }

//    var locationOptions = LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);
//    _streamSubscription = getPositionStream().listen(
//            (Position position) {
//          _position = position;
//          final coordinates = new Coordinates(position.latitude, position.longitude);
//          convertCoordinatesToAddress(coordinates).then((value)=>_address = value);
//          _address == null ? locationController.text = "getting address" : locationController.text = _address.addressLine;
//
//        });



  }
  _getAddress(LatLng lat) async
  {
     var coordinates = new Coordinates(lat.latitude, lat.longitude);
     var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
     var address1 = address.first.featureName;
     var address2 = address.first.addressLine;
     setState(() {
       finalAddress = address2;
       finalAddress == null ? locationController.text = "getting address.." :
       locationController.text = finalAddress;
     });

  }

  Future<Address>convertCoordinatesToAddress(Coordinates coordinates) async{
    var address = Geocoder.local.findAddressesFromCoordinates(coordinates);
    return address.asStream().forEach((element)
    {
      return element.first;
    });

  }
}