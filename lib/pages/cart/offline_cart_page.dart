import 'package:flutter/material.dart';

class OfflineCartPage extends StatefulWidget {
  @override
  _OfflineCartPageState createState() => _OfflineCartPageState();
}

class _OfflineCartPageState extends State<OfflineCartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.5,
        centerTitle: true,
        title: Text('Cart'),
      ),
      body: ListView(
        children: <Widget>[

        ],
      ),
    );
  }
}
