import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mmproto/Screens/login_screen.dart';

class GoogleSignInProvider extends ChangeNotifier{
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async{
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken:googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    // notifyListeners();

  }
  Future logout() async{
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }

  bool isTicketSelling = false;
  var data;
  void switchRadio(value){
    data=value;
    notifyListeners();
  }
  bool showStatus(){
    notifyListeners();
    return isTicketSelling;

  }

  Future<void> dataToServer()async{
    final event = FirebaseFirestore.instance.collection("event").doc();
    final json = {
      'id':event.id,
      'user':data['user'],
      'marker':data['marker'],
      'title':data['title'],
      'date':data['date'],
      'time':data['time'],
      'desc':data['desc'],
      'art':data['art']
    };

    await event.set(json);
  }



  // Future<QuerySnapshot?> dataFromServer()async{
  //   return eventData;
  //
  // }



}

