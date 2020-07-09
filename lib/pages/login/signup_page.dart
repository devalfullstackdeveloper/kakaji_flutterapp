import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kakaji/utils/connection.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController =TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  String validateRequired(String value) {
    if (value.length == 0) {
      return "This field is Required";
    }
    return null;
  }

  String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "This field is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Name";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "This field is Required";
    } else if(!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validateMobile(String value) {
    String pattern = r'^(?:[+0]9)?[0-9]{10}$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "This field is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Mobile Number";
    } else {
      return null;
    }
  }

  _signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('${_nameController.text} ${_mobileController.text} ${_emailController.text}'
          '${_usernameController.text} ${_passwordController.text} ${_confirmPassController.text}');
      var response = await http.post(Connection.signUp, body: {
        'name' : _nameController.text,
        'phone' : _mobileController.text,
        'email' : _emailController.text,
        'username' : _usernameController.text,
        'password' : _passwordController.text,
        'cpassword' : _confirmPassController.text,
      });
      var decodedData = json.decode(response.body);
      print("sign up $decodedData");
      if (decodedData['status'] == true) {
        _showAlertAndPop('Registration Successful', 'User have been registered successfully.');
      } else {
        String msg = '';
        for (var i in decodedData['message']) {
          msg += '$i,  ';
        }
        _showAlert('Registration Failed', '$msg');
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/books_bg.jpg'),
            fit: BoxFit.cover)
      ),
      child: Scaffold(backgroundColor: Color(0xAA000000),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Form(autovalidate: _autoValidate, key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15,),
//                  Center(child: Image.asset('assets/logo.png', height: 80, width: 270,
//                    fit: BoxFit.fill,)),
                  SizedBox(height: 60,),
                  Text("Sign Up", style: TextStyle(fontWeight: FontWeight.w700,
                      color: Colors.orange, fontSize: 24),),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _nameController,
                    validator: validateName,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: "Full Name",
                      labelStyle: TextStyle(color: Colors.white)
                    ),
                  ),
                  SizedBox(height: 12,),
                  TextFormField(
                    controller: _mobileController,
                    validator: validateMobile,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: "Mobile",
                        labelStyle: TextStyle(color: Colors.white)
                    ),
                  ),
                  SizedBox(height: 12,),
                  TextFormField(
                    controller: _emailController,
                    validator: validateEmail,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.white)
                    ),
                  ),
                  SizedBox(height: 12,),
                  TextFormField(
                    controller: _usernameController,
                    validator: validateRequired,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        labelText: "Username",
                        labelStyle: TextStyle(color: Colors.white)
                    ),
                  ),
                  SizedBox(height: 12,),
                  TextFormField(
                    controller: _passwordController,
                    validator: validateRequired,
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.white)
                    ),
                  ),
                  SizedBox(height: 12,),
                  TextFormField(
                    controller: _confirmPassController,
                    validator: validateRequired,
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(color: Colors.white)
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    width: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.all(12.0),
                      shape: StadiumBorder(),
                      child: Text("SIGN UP",
                        style: TextStyle(color: Colors.white),),
                      color: Colors.orange,
                      onPressed: _signUp,
                    ),
                  ),
                  SizedBox(height: 25.0,),
                  GestureDetector(
                    child: Text("Already Have An Account ?",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showAlertAndPop(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("Okay", style: TextStyle(color: Colors.green),),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(this.context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("Okay", style: TextStyle(color: Colors.green),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}
