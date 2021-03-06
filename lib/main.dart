import 'package:flutter/material.dart';
import 'package:mmproto/Screens/login_screen.dart';
import 'package:mmproto/Screens/map_screen.dart';
import 'package:provider/provider.dart';
import 'Provider/google_sign_in.dart';
import 'Screens/Navigator_screen.dart';


import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider(create: (context)=> GoogleSignInProvider(),child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loginScreen(),
    ),);
  }





