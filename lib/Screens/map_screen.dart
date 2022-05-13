import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {


  List<Marker> _marker = [

    // buildMarker(context,LatLng(lat, long+1),"2","mgchj"),
    // buildMarker(context,LatLng(lat-1, long),"3","mgchj"),
    // buildMarker(context,LatLng(lat, long-1),"4","mgchj"),
    // buildMarker(context,LatLng(lat, long),"5","mgchj"),

  ] ;
  double lat = 10.525252080548244;
  double long = 76.21449784404028;

  List arr = [{"latLong":LatLng(10.525252080548244+1, 76.21449784404028),"id":"1","pid":"sdfgjuy"},
    {"latLong":LatLng(10.525252080548244-1, 76.21449784404028),"id":"2","pid":"sdfgjuy"},
    {"latLong":LatLng(10.525252080548244, 76.21449784404028),"id":"3","pid":"sdfgjuy"},
    {"latLong":LatLng(10.525252080548244, 76.21449784404028-1),"id":"4","pid":"sdfgjuy"},
    {"latLong":LatLng(10.525252080548244, 76.21449784404028+1),"id":"5","pid":"sdfgjuy"}];

  void kkk(){
    for(int i = 0;i<=4;i++){
      _marker.add(buildMarker(context, arr[i]["latLong"], arr[i]["id"], arr[i]["pid"]));
      print("**************************************************");
      print(_marker);
    }
  }


  @override
  initState(){
    kkk();
    super.initState();
  }

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


  int count = 0;



  Widget build(BuildContext context) {






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
          // onTap: (LatLng val){
          //   print(val);
          //   Marker newMarker = Marker(markerId:MarkerId("$count") ,position:LatLng(val.latitude,val.longitude),infoWindow: InfoWindow(title: "new"));
          //   //
          //   _newMarker.add(newMarker);
          //   // _marker.addAll(_newMarker);
          //
          //
          //
          //   // print(count);
          //   count++;
          //   // print(_marker.length);
          //   // print(_newMarker.length);
          //   // print(_marker);
          //
          //   setState(() {});
          // },
          onLongPress: (val){
            print("____________________________________________________________________________________${val}________________________________________________");
          },

          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers:_marker.map((e) => e).toSet(),
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

  Marker buildMarker(BuildContext context,LatLng latLng,String id,String pid) {

    return Marker(markerId: MarkerId(id),
        position: latLng,
        infoWindow: const InfoWindow(
            title: "you are here"
        ),
        onTap: (){
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) => Bsheet(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
              ));
        }
    );
  }
}



class Bsheet extends StatelessWidget {
  const Bsheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(0),
              bottomLeft: Radius.circular(0))),
      margin: EdgeInsets.only(left: 30, top: 40, bottom: 0, right: 30),
      height: queryData.size.height * 0.30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Just the mail,",
            style: TextStyle(
              wordSpacing: 2,
              fontSize: 25,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            "we got you covered !",
            style: TextStyle(
              fontSize: 25,
              wordSpacing: 2,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            width: queryData.size.width * 0.6,
            height: 50,
            child: TextField(
              onChanged: (val) {},
              decoration: InputDecoration(
                  hintText: "tcr*******@gectcr.ac.in",
                  hintStyle: TextStyle(letterSpacing: 3),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {

            },
            child: Text(
              "Verify →",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, color: Colors.blueAccent),
            ),
          )
        ],
      ),
    );
  }
}
