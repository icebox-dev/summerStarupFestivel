import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:mmproto/Screens/loading_screen.dart';
import 'package:mmproto/Screens/login_screen.dart';
import 'package:mmproto/Screens/title_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../Provider/google_sign_in.dart';





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







  
  List arr = [
    // {"latLong":LatLng(10.525252080548244+1, 76.21449784404028),"id":"1","pid":"sdfgjuy"},
    // {"latLong":LatLng(10.525252080548244-1, 76.21449784404028),"id":"2","pid":"sdfgjuy"},
    // {"latLong":LatLng(10.525252080548244, 76.21449784404028),"id":"3","pid":"sdfgjuy"},
    // {"latLong":LatLng(10.525252080548244, 76.21449784404028-1),"id":"4","pid":"sdfgjuy"},
    // {"latLong":LatLng(10.525252080548244, 76.21449784404028+1),"id":"5","pid":"sdfgjuy"}
  ];
  late List<DocumentSnapshot> docs;

  Future<dynamic> fetchEvent() async{
    print("-----------------------------------------------------------------------------------------------------------------------------------");
    final docRef = await FirebaseFirestore.instance.collection("event").get().then(
          (res) {
            print("dat collected");
            docs = res.docs;
            // // arr= docs;
            // print(docs[0]["marker"]);
            // print(docs.length);
            for(int i=0;i<docs.length;i++){
              double latitude = double.parse(docs[i]["marker"].substring(7,docs[i]["marker"].length-1).split(', ')[0]);
              double longitude = double.parse(docs[i]["marker"].substring(7,docs[i]["marker"].length-1).split(', ')[1]);
              // print(latitude);
              // print(longitude);
              // print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                    _marker.add(buildMarker(context, LatLng(latitude, longitude),docs[i]["id"] , docs[i]["title"]));

            }
            setState(() {

            });
          },
      onError: (e) => print("Error completing: $e"),
    );


    // print(arr);
  }

  void sample () async{
    await fetchEvent();
  }


  @override
  initState(){
    sample();
    print("-----------------------------------------------------------------------------------------------------------------------******");
    print(_marker);

    super.initState();
  }




  Widget build(BuildContext context) {

    final _currentUser = FirebaseAuth.instance.currentUser!;
    if (_currentUser == null){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>loginScreen()));
    }


    Completer<GoogleMapController> _controller = Completer();


    Future<Position> _determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position _location=await Geolocator.getCurrentPosition();

      //Position? position = await Geolocator.getLastKnownPosition();

      LatLng  latLongPosition=  LatLng(_location.latitude, _location.longitude);

      CameraPosition cameraPosition = CameraPosition(target: latLongPosition,zoom: 15);


      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      return _location;

    }
    Future<Position> _previousPosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position _location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      LatLng  latLongPosition=  LatLng(_location.latitude, _location.longitude);

      CameraPosition cameraPosition = CameraPosition(target: latLongPosition,zoom: 15);


      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      return _location;

    }

    // dynamic _position = _determinePosition();
    // LatLng  latLongPosition=  LatLng(_position.latitude, _position.longitude);
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(lat,long),
      zoom: 14.4746,
    );


    // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child:
        Stack(
          children: [
            GoogleMap( mapType: MapType.normal,
              onLongPress: (val){
                showModalBottomSheet(

                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) => BformSheet(latLng: val,user:_currentUser.uid),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15)),
                    ));
              },

              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              // myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers:_marker.map((e) => e).toSet(),
            ),Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(onLongPress: (){
                setState(() {

                });
              }
                  ,onPressed: (){
                final provider = Provider.of<GoogleSignInProvider>(context,listen:false);
                provider.logout();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>loginScreen()));
              },
                  child: Text("LogOut",style: TextStyle(fontSize: 20),)),
            ),

          ],
        ),
      ),
      floatingActionButton: Transform.scale(
        scale: 1.2,
        child: FloatingActionButton.extended(


          label: Icon(Icons.location_on,size: 30,),
          shape: CircleBorder(),
          onPressed: _determinePosition,

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
      height: double.maxFinite < queryData.size.height * 0.750 ? null:queryData.size.height * 0.750,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "J",
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
                onChanged: (val) {

                },
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
            ),
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
                onChanged: (val) {

                },
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
            ),
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
                onChanged: (val) {

                },
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
            ),
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
                onChanged: (val) {

                },
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
            ),
          ],
        ),
      ),
    );
  }
}

class BformSheet extends StatefulWidget {
  BformSheet({
    required this.latLng,required this.user,
  }) ;
  final LatLng latLng;
  final String user;

  @override
  State<BformSheet> createState() => _BformSheetState();
}

class _BformSheetState extends State<BformSheet> {
  Object? val=false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
      final provider = Provider.of<GoogleSignInProvider>(context,listen:false);
    // bool _opt = provider.isTicketSelling;

    final TextEditingController _tControllerTitle = TextEditingController();
    final TextEditingController _tControllerDate = TextEditingController();
    final TextEditingController _tControllerTime = TextEditingController();
    final TextEditingController _tControllerArt = TextEditingController();
    final TextEditingController _tControllerDesc = TextEditingController();
    final TextEditingController _tControllerTicket = TextEditingController();
     String _title ;
     String _date ;
     String _time ;
     String _art ;
     String _desc ;


    Future<dynamic> createEvent(
        {required String user,required LatLng latLng,
          required String title,
          required String date,
          required String time,
          required String desc,
          required String art,
        })async{

      final json = {
        'user':user,
        'marker':latLng.toString(),
        'title':title,
        'date':date,
        'time':time,
        'desc':desc,
        'art':art
      };
      provider.switchRadio(json);
      // print(json);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoadingScreen(func: provider.dataToServer())));

    };




    return Padding(
      padding: queryData.viewInsets,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(0),
                bottomLeft: Radius.circular(0))),
        margin: EdgeInsets.only(left: 30, top: 40, bottom: 0, right: 30),
        height: queryData.size.height * 0.70,
        child: SingleChildScrollView(

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
                  controller: _tControllerTitle,
                  onChanged: (val) {
                    _title = val;
                  },

                  decoration: InputDecoration(
                    label: Text("Title"),
                      // hintText: "tcr*******@gectcr.ac.in",
                      hintStyle: TextStyle(letterSpacing: 3),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                height: 40,
              ),


              Row(mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  SizedBox(
                    width: queryData.size.width * 0.4,
                    height: 50,
                    child: TextField(
                      controller: _tControllerDate,
                      onChanged: (val) {
                          _date=val;
                      },

                      decoration: InputDecoration(
                          label: Text("Date"),
                          // hintText: "tcr*******@gectcr.ac.in",
                          hintStyle: TextStyle(letterSpacing: 3),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    width: queryData.size.width * 0.05,

                  ),
                  SizedBox(
                    width: queryData.size.width * 0.4,
                    height: 50,
                    child: TextField(
                      controller: _tControllerTime,
                      onChanged: (val) {
                        _time=val;

                      },

                      decoration: InputDecoration(
                          label: Text("Time"),
                          // hintText: "tcr*******@gectcr.ac.in",
                          hintStyle: TextStyle(letterSpacing: 3),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),

              SizedBox(
                width: queryData.size.width * 0.6,
                height: 50,
                child: TextField(
                  controller: _tControllerArt,
                  onChanged: (val) {
                    _art=val;

                  },

                  decoration: InputDecoration(
                      label: Text("Art Form"),
                      // hintText: "tcr*******@gectcr.ac.in",
                      hintStyle: TextStyle(letterSpacing: 3),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                width: queryData.size.width * 0.6,
                // height: 50,
                child: TextField(
                  minLines: 6,
                  maxLines: 25,
                  controller: _tControllerDesc,
                  onChanged: (val) {
                    _desc=val;

                  },

                  decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      label: Text("Description"),
                      labelStyle: TextStyle(


                      ),
                      // hintText: "tcr*******@gectcr.ac.in",
                      hintStyle: TextStyle(letterSpacing: 3),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                height: 40,
              ),
  //             Row(children: [
  //               Text("Is Ticket Selling ?",
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   color: Colors.black.withOpacity(.65)
  //
  //
  //               ),),
  //
  // ]),

              GestureDetector(
                onTap: () {
                    createEvent(user:widget.user,latLng:widget.latLng,title:_tControllerTitle.value.text,date:_tControllerDate.value.text,time:_tControllerTime.value.text,desc:_tControllerDesc.value.text,art: _tControllerArt.value.text);
                },
                child: Text(
                  "Verify →",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
