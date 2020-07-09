import 'dart:convert';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kakaji/pages/profile/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakaji/pages/login/signup_page.dart';
import 'package:kakaji/utils/connection.dart';
import '../../main.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'dart:io';

import '../home_page.dart';

class LoginPage extends StatefulWidget {



  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showAlert('Alert', 'Both Mobile Number and OTP fields are required to fill in.');
      return;
    }
    print("password ${_passwordController.text}");
    var response = await http.post(Connection.checkopt, body: {
      'uid' : uid.toString(),
      'otp' : '${_passwordController.text}',
    });
    var decodedData = json.decode(response.body);
    print("Decoded Data $decodedData");
    if (decodedData['status'] == true) {
      print('id is ${decodedData['data']['id']} and name is ${decodedData['data']['fname']}');
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setInt("user_id", decodedData['data']['id']);
      _prefs.setString("fname", decodedData['data']['fname']);
      _prefs.setString("username", decodedData['data']['username']);
      _prefs.setString("email", decodedData['data']['email']);
      _prefs.setString("phone", decodedData['data']['phone']);
      _prefs.setString("address", decodedData['data']['address']);
      _prefs.setString("city", decodedData['data']['city']);
      _prefs.setString("state", decodedData['data']['state']);
      _prefs.setString("postcode", decodedData['data']['postcode']);
      _prefs.setString("approve", decodedData['data']['approve']);
      _prefs.setString("hide_status", decodedData['data']['hide_status']);
      _prefs.setString("country", decodedData['data']['country']);
      _prefs.setString("house", decodedData['data']['house']);
      _prefs.setString("street", decodedData['data']['street']);
      _prefs.setString("landmark", decodedData['data']['landmark']);
      _prefs.setString("area", decodedData['data']['area']);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => PageSelector()));
    } else {
      _showAlert('Login Failed', 'Something went wrong while logging in.');
    }
  }

  var otp,uid;

  _getotp() async {
    if (_usernameController.text.isEmpty || _usernameController.text.length != 10) {
      _showAlert('Alert', 'Both username and password fields are required to fill in.');
      return;
    }
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    var response = await http.post(Connection.login, body: {
      'mobile' : '${_usernameController.text}',

    });

    var decodedData = json.decode(response.body);
    print("Decoded Data $decodedData");
    var data= decodedData['data'];
     uid = data['uid'];
//     otp = data['otp'];
    //_passwordController.text = otp.toString();
//    if (decodedData['status'] == true) {
//      print('id is ${decodedData['data']['id']} and name is ${decodedData['data']['fname']}');
//      SharedPreferences _prefs = await SharedPreferences.getInstance();
//      _prefs.setInt("user_id", decodedData['data']['id']);
//      _prefs.setString("fname", decodedData['data']['fname']);
//      _prefs.setString("username", decodedData['data']['username']);
//      _prefs.setString("email", decodedData['data']['email']);
//      _prefs.setString("phone", decodedData['data']['phone']);
//      _prefs.setString("address", decodedData['data']['address']);
//      _prefs.setString("city", decodedData['data']['city']);
//      _prefs.setString("state", decodedData['data']['state']);
//      _prefs.setString("postcode", decodedData['data']['postcode']);
//      _prefs.setString("approve", decodedData['data']['approve']);
//      _prefs.setString("hide_status", decodedData['data']['hide_status']);
//      _prefs.setString("country", decodedData['data']['country']);
//      _prefs.setString("house", decodedData['data']['house']);
//      _prefs.setString("street", decodedData['data']['street']);
//      _prefs.setString("landmark", decodedData['data']['landmark']);
//      _prefs.setString("area", decodedData['data']['area']);
//      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => PageSelector()));
//    } else {
//      _showAlert('Login Failed', 'Something went wrong while logging in.');
//    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _checkUser();
    _checkinternet();
  }

  _checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => NoInternet()));

     // _showAlertnointernet('Alert', 'No Internet Connection0');
    }
  }

  int userId = 0;

  _checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("user_id") ?? 0;
      print('user id is $userId');
      if(userId!= 0){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => PageSelector()));
      }
      userId == 0 ? HomePage() : Home();
    });
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/books_bg.jpg'),
            fit: BoxFit.cover)
      ),
      child: Scaffold(
        backgroundColor: Color(0xAA000000),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//                Center(child: Image.asset('assets/kakajilgo.png', height: 230, width: 200,
//                  fit: BoxFit.fill,)),
                SizedBox(height: 20,),
                Text("Login", style: TextStyle(fontWeight: FontWeight.w700,
                    color: Colors.orange, fontSize: 24),),
                SizedBox(height: 12,),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .70,
                      child: TextField(
                        controller: _usernameController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          labelText: "Mobile No",
                          labelStyle: TextStyle(color: Colors.white)
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    Container(
                      width: MediaQuery.of(context).size.width * .17,
                      child: ArgonTimerButton(
                        height: 40,
                        width: MediaQuery.of(context).size.width * .17,
                        minWidth: MediaQuery.of(context).size.width * .17,
                        highlightColor: Colors.transparent,
                        highlightElevation: 0,
                        roundLoadingShape: false,
                        onTap: (startTimer, btnState) {
                          if (_usernameController.text.isEmpty || _usernameController.text.length != 10) {
                            _showAlert('Alert', 'Enter valid mobile Number');
                            return;
                          }
                          else if (btnState == ButtonState.Idle) {
                            startTimer(30);
                            _getotp();
                          }
                        },
                        // initialTimer: 10,
                        child: Text(
                          "Send OTP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                        loader: (timeLeft) {
                          return Text(
                            "Wait | $timeLeft",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          );
                        },
                        borderRadius: 5.0,
                        color:  Colors.orange,
                        elevation: 0,
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
//                      child:  RaisedButton(
//                        padding: EdgeInsets.all(0.0),
//                        shape: StadiumBorder(),
//                        child: Text("Get  SMS", style: TextStyle(color: Colors.white,fontSize: 12),),
//                        color: Colors.orange,
//                        onPressed: _getotp,
//                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12,),
                TextField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white),
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: "Enter OTP",
                    labelStyle: TextStyle(color: Colors.white)
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.all(12.0),
                    shape: StadiumBorder(),
                    child: Text("LOGIN", style: TextStyle(color: Colors.white),),
                    color: Colors.orange,
                    onPressed: _login,
                  ),
                ),
                SizedBox(height: 20,),
//                GestureDetector(
//                  child: Text("Skip Login",
//                    style: TextStyle(color: Colors.white,fontSize: 18),),
//                  onTap: () {
//                    Navigator.pushReplacement(context,
//                        MaterialPageRoute(builder: (c)=> HomePage()));
//                  },
//                ),
//                Padding(
//                  padding: const EdgeInsets.only(top:70,bottom: 10),
//                  child: GestureDetector(
//                    child: Text("SIGN UP FOR AN ACCOUNT",
//                      style: TextStyle(color: Colors.white,fontSize: 18),
//                    ),
//                    onTap: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (c)=> SignUpPage()));
//                    },
//                  ),
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay", style: TextStyle(color: Colors.orange),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showAlertnointernet(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay", style: TextStyle(color: Colors.orange),),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MyApp()));
              },
            ),
          ],
        );
      },
    );
  }


}

