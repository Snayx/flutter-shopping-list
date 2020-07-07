import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationTracker = Location();
  var locationData;
  static CameraPosition initialLocation = CameraPosition(
    target: LatLng(0.000, 0.000),
    zoom: 20.0,
  );
  GoogleMapController _controller;
  StreamSubscription _locationSubscription;

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initialLocation,
          zoomGesturesEnabled: true,
          padding: EdgeInsets.all(5.0),
          trafficEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          buildingsEnabled: true,
          indoorViewEnabled: true,
          mapToolbarEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            getCurrentLocation();
          },
        ),
      ),
    );
  }
  void getCurrentLocation() async {
    try {
      var location = await _locationTracker.getLocation();
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
            if (_controller != null) {
              _controller.animateCamera(CameraUpdate.newCameraPosition(
                  new CameraPosition(
                      bearing: 192.8334901395799,
                      target: LatLng(newLocalData.latitude, newLocalData.longitude),
                      tilt: 5,
                      zoom: 17.20)));
            }
          });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }
}