import 'package:flutter/material.dart';
import 'package:kakaji/main.dart';

class NoInternet extends StatefulWidget {
  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Text('No Internet Connection',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold) ,),
            Text('Check your Internet Connection',style:TextStyle(fontSize: 16) ,),

            SizedBox(height: 20,),

            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MyApp()));
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Text("Retry now".toUpperCase(),
                  style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
