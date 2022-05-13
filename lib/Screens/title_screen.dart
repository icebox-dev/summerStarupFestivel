import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/google_sign_in.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FloatingActionButton(
            child: Text("LogOut"),onPressed: (){
            final provider = Provider.of<GoogleSignInProvider>(context,listen:false);
            provider.logout();
          },
          ),
        ),
      ),
    );
  }
}
