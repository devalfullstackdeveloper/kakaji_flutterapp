import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kakaji/main.dart';
import 'package:kakaji/pages/home_page.dart';
import 'package:kakaji/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PageSelector()));

   // Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();

  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: Center(
          child:   Container(
              height:MediaQuery.of(context).size.height,
              child: Image.asset("assets/splash.jpg",fit: BoxFit.fitHeight,)),
      ),
    );
  }
}
