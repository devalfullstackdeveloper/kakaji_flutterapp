import 'dart:io';
import 'package:connectivity_widget/connectivity_widget.dart';

import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakaji/pages/profile/FavouriteList.dart';
import 'package:kakaji/utils/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakaji/pages/cart/cart_page.dart';
import 'package:kakaji/pages/contactus_page.dart';
import 'package:kakaji/pages/home_page.dart';
import 'package:kakaji/pages/profile/order_history_page.dart';
import 'package:kakaji/pages/profile/profile_page.dart';
import 'package:kakaji/utils/apptheme.dart';
import 'pages/login/login_page.dart';
import 'pages/profile/NoInternet.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() {
  HttpOverrides.global = new MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Kakaji',
      theme: ThemeData(
        primaryColor: Colors.white,
        //primaryColor: Colors.red,

      ),
      home: Splash(),
    //  home: NoInternet(),
    );
  }
}

class PageSelector extends StatefulWidget {
  @override
  _PageSelectorState createState() => _PageSelectorState();
}

class _PageSelectorState extends State<PageSelector> {
  int userId = 0;
  _checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("user_id") ?? 0;
      print('user id is $userId');
    });
  }

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    //return Splash();
    return userId == 0 ? LoginPage() : Home();
  }
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> _pageOptions = [
    HomePage(),
    FavouriteList(),
    OrderHistoryPage(),
    ProfilePage(),
  ];

  _showAlertclose(String title, String message) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("Okay", style: TextStyle(color: AppTheme.redColor),),
              onPressed: () {
               exit(0);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        _showAlertclose('Alert','Are you sure you want to close the app ?');
      },
      child: Scaffold(
        body: _pageOptions[_selectedIndex],
        //      body: IndexedStack(
        //        index: _selectedIndex,
        //        children: _pageOptions,
        //      ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppTheme.redColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: AppTheme.yellowColor,
            unselectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {

                _selectedIndex = index;

              });
            },
            items: [
              BottomNavigationBarItem(
                title: Container(height: 5,),
                icon: Icon(Icons.home, size: 30,),
              ),
              BottomNavigationBarItem(
                title: Container(height: 5,),
                icon: Icon(Icons.favorite, size: 30,),
              ),
              BottomNavigationBarItem(
                title: Container(height: 5,),
                icon: Icon(Icons.history, size: 30,),
              ),
              BottomNavigationBarItem(
                title: Container(height: 5,),
                icon: Icon(Icons.person, size: 30,),
              ),
            ]),
      ),
    );
  }
}


