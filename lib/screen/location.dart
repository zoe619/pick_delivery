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

class Map2 extends StatefulWidget
{
  final int id;

  Map2({this.id});
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
            child: TextField(
              onTap: ()async{
                Prediction p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: "AIzaSyD6dxWCuUM3KXxzuaDFn8KErN4-U2AWIIo",
                    mode: Mode.overlay, // Mode.fullscreen
                    onError: onError,
                    language: "en",
                    components: [new Component(Component.country, "ng")]);
                    displayPrediction(p, locationScaffoldKey.currentState);
              },
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
                      child: text("Confirm", fontSize: textSizeLargeMedium, textColor: t1_white, fontFamily: fontMedium),
                      textColor: t1_white,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
                      color: t1_colorPrimary, onPressed: ()
                      {

                         if(widget.id == 1)
                         {

                           Provider.of<UserData>(context, listen: false).pickAddress
                           = _finalAddress;
                         }
                         else if(widget.id == 2){
                           Provider.of<UserData>(context, listen: false).deliveryAddress
                           = _finalAddress;
                         }
                         _calculateDistance();
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_)=>T1Dashboard(mapId: widget.id),
                        ));
                      }
                  ),
                )),
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



  }
  _getAddress(LatLng lat) async
  {
     var coordinates = new Coordinates(lat.latitude, lat.longitude);
     var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
     var address1 = address.first.featureName;
     var address2 = address.first.addressLine;
     setState(() {
       _finalAddress = address2;
       _finalAddress == null ? locationController.text = "getting address.." :
       locationController.text = _finalAddress;
     });
     if(widget.id == 1)
     {
       Provider.of<UserData>(context, listen: false).pickLatitude = lat.latitude;
       Provider.of<UserData>(context, listen: false).pickLongitude = lat.longitude;
     }
     else if(widget.id == 2)
     {
       Provider.of<UserData>(context, listen: false).deliveryLatitude = lat.latitude;
       Provider.of<UserData>(context, listen: false).deliveryLongitude = lat.longitude;

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

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async
  {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

//      scaffold.showSnackBar(
//        SnackBar(content: Text("${p.description} - $lat/$lng")),
//      );
      setState(()
      {
        locationController.text = p.description;
        _finalAddress = locationController.text;

        if(widget.id == 1)
        {
          Provider.of<UserData>(context, listen: false).pickLatitude = lat;
          Provider.of<UserData>(context, listen: false).pickLongitude = lng;
        }
        else if(widget.id == 2)
        {
          Provider.of<UserData>(context, listen: false).deliveryLatitude = lat;
          Provider.of<UserData>(context, listen: false).deliveryLongitude = lng;

        }
      });

    }
  }
  _calculateDistance()
  {
    if(Provider.of<UserData>(context, listen: false).pickLatitude != null &&
        Provider.of<UserData>(context, listen: false).pickLongitude != null &&
        Provider.of<UserData>(context, listen: false).deliveryLatitude != null &&
        Provider.of<UserData>(context, listen: false).deliveryLongitude != null)
    {
      double distanceInMeters = distanceBetween(Provider.of<UserData>(context, listen: false).pickLatitude,
          Provider.of<UserData>(context, listen: false).pickLongitude,
          Provider.of<UserData>(context, listen: false).deliveryLatitude,
          Provider.of<UserData>(context, listen: false).pickLongitude);

      Provider.of<UserData>(context, listen: false).distance = distanceInMeters;

    }

  }
}