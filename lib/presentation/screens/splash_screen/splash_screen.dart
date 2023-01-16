import 'package:flutter/material.dart';

import '../main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
     Future.delayed(Duration(seconds: 1),(){
       Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
     });
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: SafeArea(child:
      Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Image.asset(
            'assets/images/app_logo.png',
            fit: BoxFit.cover,
            height: 150,
            width: 150,
          ),
          SizedBox(height: 30,),
           CircularProgressIndicator(
           ),

        ],),
      )),
    );
  }
}
