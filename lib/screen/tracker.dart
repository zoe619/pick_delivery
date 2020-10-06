import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pick_delivery/model/order.dart';
import 'package:pick_delivery/utilities/constant.dart';
import 'package:pick_delivery/utils/T1Colors.dart';
import 'package:rxdart/rxdart.dart';


class Tracker extends StatefulWidget
{
  final String id;
  final Order order;
//  final double pickLatitude, pickLongitude, deliveryLatitude, deliveryLongitude;
  Tracker({this.id, this.order});

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker>
{
  GoogleMapController _mapController;
  Location _location = new Location();
  Geoflutterfire geo = Geoflutterfire();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Stream<dynamic> _query;
  StreamSubscription _streamSubscription;


  final radius = BehaviorSubject<double>.seeded(200.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addGeoPoint();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: t1_colorPrimary,
        title: const Text('Pick delivery Tracker'),
        actions: <Widget>[
          IconButton(
            onPressed: _mapController == null
                ? null
                : () {
              _animateToUser();
            },
            icon: Icon(Icons.home),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(widget.order.pickLatitude), double.parse(widget.order.pickLongitude)),
              zoom: 15
            ),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            mapType: MapType.hybrid,
            compassEnabled: true,
          ),
//          Positioned(
//            bottom: 50,
//            right: 10,
//            child: FlatButton(
//              child: Icon(Icons.pin_drop, color: Colors.white),
//              color: Colors.green,
//              onPressed:(){},
//
//            ),
//          ),
          Positioned(
            bottom: 50,
            left: 10,
            child: Slider(
              min: 100.0,
              max: 500.0,
              divisions: 4,
              value: radius.value,
              label: 'Radius ${radius.value}km',
              activeColor: Colors.green,
              inactiveColor: Colors.green.withOpacity(0.2),
              onChanged: _updateQuery,

            ),
          )
        ],

      ),
    );
  }

  _onMapCreated(GoogleMapController controller)
  {
    _startQuery();
     setState(() {
       _mapController = controller;
     });
  }

  Future<Uint8List>_getMarker()async
  {
    final ByteData markerIcon =
    await DefaultAssetBundle.of(context).load("images/theme1/bike2.png");
    return markerIcon.buffer.asUint8List();
  }


  Future<void> _addMarker(double lat, double lng, String name) async
  {
    final Uint8List markerIcon = await _getMarker();
    final id = MarkerId(lat.toString() + lng.toString());
    final _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.fromBytes(markerIcon),
      infoWindow: InfoWindow(title: '$name', snippet: '$lat,$lng'),
    );
    setState(() {
      markers[id] = _marker;
    });
  }


  _animateToUser()async
  {

    _location.onLocationChanged.listen((LocationData currentLocation)
    {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 17.0
          ))
      );
      // Use current location
    });
  }

  Future<DocumentReference> _addGeoPoint() async
  {
    var pos = await _location.getLocation();
    GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
    return locationsRef.add({
      'position': point.data,
      'name': 'pick delivery',
       'id': widget.id
    });
  }

  _updateQuery(double value)
  {
     final zoomMap = {
       100.0 : 12.0,
       200.0 : 10.0,
       300.0 : 7.0,
       400.0 : 6.0,
       500.0 : 7.0
     };
     final zoom = zoomMap[value];
     _mapController.moveCamera(CameraUpdate.zoomTo(zoom));
     setState(() {
       radius.add(value);
     });
  }

  _updateMarkers(List<DocumentSnapshot> document)
  {
    _mapController.dispose();
    document.forEach((DocumentSnapshot doc)
    {
      final GeoPoint point = doc.data()['position']['geopoint'];
      double distance = doc.data()['distance'];
      _addMarker(point.latitude, point.longitude,doc.data()['name']);
    });
  }

  _startQuery()async{
    var pos = await _location.getLocation();
    double latitude = pos.latitude;
    double longitude = pos.longitude;

    var queryRef = locationsRef.where('id', isEqualTo: widget.id);
    GeoFirePoint center = geo.point(latitude: double.parse(widget.order.pickLatitude),
        longitude: double.parse(widget.order.pickLongitude));
    
    _streamSubscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: queryRef).within(
          center: center,
          radius: double.parse(widget.order.distance) * 2,
          field: 'position',
          strictMode: true
      );
    }).listen(_updateMarkers);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mapController.dispose();
    _streamSubscription.cancel();
  }

}
