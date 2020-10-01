import 'dart:async';
import 'dart:collection';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pick_delivery/model/user_data.dart';
import 'package:pick_delivery/screen/T1Dashboard.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:pick_delivery/utils/T1Constant.dart';
import 'package:pick_delivery/utils/T1Widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Tracker extends StatefulWidget
{

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker>
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

  final locationScaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyD6dxWCuUM3KXxzuaDFn8KErN4-U2AWIIo");

  var _finalAddress;

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
          key: locationScaffoldKey,
          appBar: AppBar(
            title: Center(child: Text('Pick delivery',
              style: TextStyle(
                  color: t1TextColorPrimary
              ),)),
            backgroundColor: t1_white,

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


                },
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
                ),
              ),

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
                ),
              ),
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

    }



  }

  Future<Address>convertCoordinatesToAddress(Coordinates coordinates) async{
    var address = Geocoder.local.findAddressesFromCoordinates(coordinates);
    return address.asStream().forEach((element)
    {
      return element.first;
    });

  }

  void onError(PlacesAutocompleteResponse response)
  {
    locationScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

}