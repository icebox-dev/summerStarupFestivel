import 'package:flutter/material.dart';
import 'package:mmproto/Screens/map_screen.dart';
import 'package:provider/provider.dart';

import '../Provider/google_sign_in.dart';


class LoadingScreen extends StatefulWidget {



  LoadingScreen({required this.func}) ;

  Future<void> func;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState(){
    super.initState();
    widget.func;
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MapScreen()));
    Navigator.pop(context);

  }
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context,listen:false);

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );;
  }
}
