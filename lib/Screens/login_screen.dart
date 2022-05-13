import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mmproto/Provider/google_sign_in.dart';
import 'package:mmproto/Screens/map_screen.dart';
import 'package:provider/provider.dart';

class loginScreen extends StatelessWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);}
            else if(snapshot.hasData){
              return MapScreen();
            }else if(snapshot.hasError){
              return Center(child: Text("Something Went Wrong!"),);
            }else{
              return loginPage();
            }
          }
        )
    );
  }
}

class loginPage extends StatelessWidget {
  const loginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(child: ElevatedButton.icon(icon:FaIcon(FontAwesomeIcons.google),label:Text("Sign in with Google"),onPressed: (){
            final provider = Provider.of<GoogleSignInProvider>(context,listen:false);
            provider.googleLogin();
          },style: ElevatedButton.styleFrom(
            primary: Colors.black,
          ),))

      ),
    );
  }
}
