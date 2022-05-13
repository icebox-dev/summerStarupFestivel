import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  
  // initState(){
  //   LocatingMe();
  //   super.initState();
  // }
  // void LocatingMe()async{
  //
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   currentLocation = position;
  //   latLongPosition=  LatLng(position.latitude, position.longitude);
  //
  //   // CameraPosition cameraPostion = CameraPosition(target: latLongPosition,zoom: 15);
  // }
  // late Position currentLocation;
  //late LatLng latLongPosition;

  double lat = 10.525252080548244;
  double long = 76.21449784404028;
  
 
  Widget build(BuildContext context) {

    List<Marker> _marker = <Marker>[
      Marker(markerId: MarkerId("1"),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(
          title: "you are here"
        )
      )
    ] ;


    Completer<GoogleMapController> _controller = Completer();

    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(lat,long),
      zoom: 14.4746,
    );
    final CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(37.43296265331129, -122.08832357078792),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    Future<void> _goToTheLake() async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    }

    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    return Scaffold(
      body: SafeArea(
        child: GoogleMap( mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers:Set<Marker>.of(_marker),
        ),
        ),
      floatingActionButton: Transform.scale(
        scale: 1.2,
        child: FloatingActionButton.extended(


          label: Icon(Icons.location_on,size: 30,),
          shape: CircleBorder(),
          onPressed: _goToTheLake,

        ),
      ),
    );
  }
}



