import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mmproto/Screens/map_screen.dart';
import 'package:mmproto/Screens/login_screen.dart';
 class NavigatorScreen extends StatelessWidget {
   const NavigatorScreen({Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: SafeArea(
         child: Column(
           children: [
             SizedBox(height: 40,),
             TextButton(onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => loginScreen()));
             }, child: Text("Login")),
             SizedBox(height: 40,),
             TextButton(onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=> MapScreen()));
             }, child: Text("Map")),
             SizedBox(height: 40,),
             TextButton(onPressed: (){
             }, child: Text("title")),
             SizedBox(height: 40,),
             TextButton(onPressed: (){
             }, child: Text("title")),
             SizedBox(height: 40,),
             TextButton(onPressed: (){
             }, child: Text("title")),


           ],
         ),
       ),
     );
   }
 }
