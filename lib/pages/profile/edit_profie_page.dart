import 'package:flutter/material.dart';
import 'package:kakaji/models/arealist.dart';
import 'package:kakaji/models/citylist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kakaji/utils/apptheme.dart';
import 'package:kakaji/utils/connection.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _isHome = true;
  var isSelected = [true, false];

  String _city;
  List<CityList> _allCities = [];
  int _cityId = 0;
  String _area;
  List<AreaList> _allAreas = [];
  int _areaId = 0;

  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _houseController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _stateController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  String validateRequired(String value) {
    if (value.length == 0) {
      return "This field is Required";
    }
    return null;
  }

  String validatePinCode(String value) {
    if (value.length != 6) {
      return "Invalid Pincode";
    }
    return null;
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

  _getCityList() async {
    var response = await http.post(Connection.cityList);
    var decodedData = json.decode(response.body);
    var webresp = decodedData['data'];
    setState(() {
      for (var i in webresp) {
        CityList cl = CityList(id: i['id'], city: i['city']);
        _allCities.add(cl);
      }
    });
  }

  _getAreaList(int cityId) async {
    var response = await http.post(Connection.areaList, body: {
      'city': '$cityId'
    });
    var decodedData = json.decode(response.body);
    var webresp = decodedData['data'];
    setState(() {
      for (var i in webresp) {
        AreaList al = AreaList(id: i['id'], aname: i['aname']);
        _allAreas.add(al);
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _getCityList();
    _getUserDetails();
  }
  _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('fname') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _mobileController.text = prefs.getString('phone') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 1.0,
        title: Text('Edit Profile'),),
      body: Form(autovalidate: _autoValidate,
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10,),
            Theme(data: ThemeData(primaryColor: AppTheme.redColor),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      validator: validateRequired,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0, color: Colors.black87),
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 11.0, 20.0, 11.0),
                        hintText: "Full Name",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),),
                      ),),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _emailController,
                      validator: validateRequired,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0, color: Colors.black87),
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 11.0, 20.0, 11.0),
                        hintText: "Email Id",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),),
                      ),),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _mobileController,
                      validator: validateMobile,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0, color: Colors.black87),
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 11.0, 20.0, 11.0),
                        hintText: "Mobile No.",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),),
                      ),),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Theme(data: ThemeData(primaryColor: AppTheme.redColor),
                child: Column(
                  children: <Widget>[
                   // SizedBox(height: 20),
                    TextFormField(
                      controller: _houseController,
                      validator: validateRequired,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0, color: Colors.black87),
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 11.0, 20.0, 11.0),
                        hintText: "Street",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),),
                      ),),
                    SizedBox(height: 15,),

                    SizedBox(height: 15,),
                    Container(height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1.1, color: Colors.grey),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(alignedDropdown: true,
                          child: DropdownButton<String>(
                            itemHeight: 55, isExpanded: true,
                            hint: Text('Please Select City',
                              style: TextStyle(color: Colors.black87, fontSize: 18),),
                            value: _city,
                            items: _allCities.map((value) {
                              return DropdownMenuItem<String>(
                                value: value.city,
                                child: Text(value.city,
                                  style: TextStyle(color: Colors.black87), maxLines: 5,),
                              );
                            }).toList(),
                            onChanged: (v) {
                              _allAreas.clear();
                              _area = null;
                              _areaId = 0;
                              setState(() {
                                _city = v;
                              });
                              _allCities.forEach((v) {
                                if (v.city == _city) {
                                  _cityId = v.id;
                                }
                              });
                              print('city id is $_cityId');
                              _getAreaList(_cityId);
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1.1, color: Colors.grey),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(alignedDropdown: true,
                          child: DropdownButton<String>(
                            itemHeight: 55, isExpanded: true,
                            hint: Text('Please Select Area',
                              style: TextStyle(color: Colors.black87, fontSize: 18),),
                            value: _area,
                            items: _allAreas.map((value) {
                              return DropdownMenuItem<String>(
                                value: value.aname,
                                child: Text(value.aname,
                                  style: TextStyle(color: Colors.black87), maxLines: 5,),
                              );
                            }).toList(),
                            onChanged: (v) {
                              setState(() {
                                _area = v;
                              });
                              _allAreas.forEach((v) {
                                if (v.aname == _area) {
                                  _areaId = v.id;
                                }
                              });
                              print('area id is $_areaId');
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _stateController,
                      validator: validateRequired,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0, color: Colors.black87),
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 11.0, 20.0, 11.0),
                        hintText: "State",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),),
                      ),),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _landmarkController,
                      validator: validateRequired,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0, color: Colors.black87),
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 11.0, 20.0, 11.0),
                        hintText: "Landmark",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),),
                      ),),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _pinCodeController,
                      validator: validateRequired,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20.0, color: Colors.black87),
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 11.0, 20.0, 11.0),
                        hintText: "Pincode",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),),
                      ),),
                  ],
                ),
              ),
            ),



            SizedBox(height: 20,),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 18),
              child: RaisedButton(color: AppTheme.redColor,
                child: Text('Submit', style: TextStyle(color: Colors.white),),
                onPressed: _doEditProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
  _doEditProfile() async {
//    if (_formKey.currentState.validate()) {
//      _formKey.currentState.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.post(Connection.editProfile, body: {
        'user_id': '${prefs.getInt('user_id') ?? 0}',
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _mobileController.text,
      });
      var decodedData = json.decode(response.body);
      print('Edit profile $decodedData');
      if (decodedData['status'] == true) {
        prefs.setString('fname', _nameController.text);
        prefs.setString('email', _emailController.text);
        prefs.setString('phone', _mobileController.text);
        _showAlertAndGoBack();
      } else {
        _showAlert('Update Failed',
            'Profile details failed to update. ${decodedData['message']}');
      }
//    } else {
//     // setState(() => _autoValidate = true);
//    }
  }

    _showAlertAndGoBack() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Update Successful'),
          content: new Text('User details has been updated successfully.'),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay", style: TextStyle(color: AppTheme.redColor),),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, [_nameController.text, _emailController.text,
                  _mobileController.text]);
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
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay", style: TextStyle(color: AppTheme.redColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showAlertAndPop(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay", style: TextStyle(color: AppTheme.redColor),),
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


}


//class _EditProfilePageState extends State<EditProfilePage> {
//  bool _autoValidate = false;
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  TextEditingController _nameController = TextEditingController();
//  TextEditingController _emailController = TextEditingController();
//  TextEditingController _mobileController = TextEditingController();
//
//  String validateName(String value) {
//    if (value.length == 0) {
//      return "This field is Required";
//    }
//    return null;
//  }
//
//  String validateEmail(String value) {
//    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//    RegExp regExp = new RegExp(pattern);
//    if (value.length == 0) {
//      return "Email is Required";
//    } else if(!regExp.hasMatch(value)) {
//      return "Invalid Email";
//    } else {
//      return null;
//    }
//  }
//
//  String validateMobile(String value) {
//    String pattern = r'^(?:[+0]9)?[0-9]{10}$';
//    RegExp regExp = new RegExp(pattern);
//    if (value.length == 0) {
//      return "This field is Required";
//    } else if (!regExp.hasMatch(value)) {
//      return "Invalid Mobile Number";
//    } else {
//      return null;
//    }
//  }
//
//  _getUserDetails() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    _nameController.text = prefs.getString('fname') ?? '';
//    _emailController.text = prefs.getString('email') ?? '';
//    _mobileController.text = prefs.getString('phone') ?? '';
//  }
//
//  _doEditProfile() async {
//    if (_formKey.currentState.validate()) {
//      _formKey.currentState.save();
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      var response = await http.post(Connection.editProfile, body: {
//        'user_id': '${prefs.getInt('user_id') ?? 0}',
//        'name': _nameController.text,
//        'email': _emailController.text,
//        'phone': _mobileController.text,
//      });
//      var decodedData = json.decode(response.body);
//      print('Edit profile $decodedData');
//      if (decodedData['status'] == true) {
//        prefs.setString('fname', _nameController.text);
//        prefs.setString('email', _emailController.text);
//        prefs.setString('phone', _mobileController.text);
//        _showAlertAndGoBack();
//      } else {
//        _showAlert('Update Failed',
//            'Profile details failed to update. ${decodedData['message']}');
//      }
//    } else {
//      setState(() => _autoValidate = true);
//    }
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    _getUserDetails();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(backgroundColor: AppTheme.separatorColor,
//      appBar: AppBar(elevation: 0.5,
//        centerTitle: true,
//        title: Text('Edit Profile'),
//      ),
//      body: ListView(
//        padding: const EdgeInsets.all(16.0),
//        children: <Widget>[
//          SizedBox(height: 20,),
//          ClipRRect(borderRadius: BorderRadius.circular(12),
//            child: Container(color: Colors.white,
//              child: Theme(data: ThemeData(primaryColor: AppTheme.redColor),
//                child: Form(
//                  autovalidate: _autoValidate,
//                  key: _formKey,
//                  child: Padding(
//                    padding: const EdgeInsets.all(18.0),
//                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        SizedBox(height: 10,),
//                        Text('  Full Name', style: TextStyle(fontSize: 18),),
//                        SizedBox(height: 10,),
//                        TextFormField(textAlign: TextAlign.center,
//                          style: TextStyle(fontSize: 20.0, color: Colors.black87),
//                          cursorColor: Colors.black87,
//                          validator: validateName,
//                          controller: _nameController,
//                          decoration: InputDecoration(
//                            contentPadding: EdgeInsets.fromLTRB(20.0, 8.6, 20.0, 8.6),
//                            hintText: "Enter Full Name",
//                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
//                              borderSide: BorderSide(color: Colors.black),),
//                          ),),
//                        SizedBox(height: 16,),
//                        Text('  Email', style: TextStyle(fontSize: 18),),
//                        SizedBox(height: 10,),
//                        TextFormField(textAlign: TextAlign.center,
//                          style: TextStyle(fontSize: 20.0, color: Colors.black87),
//                          cursorColor: Colors.black87,
//                          keyboardType: TextInputType.emailAddress,
//                          controller: _emailController,
//                          validator: validateEmail,
//                          decoration: InputDecoration(
//                            contentPadding: EdgeInsets.fromLTRB(20.0, 8.6, 20.0, 8.6),
//                            hintText: "Enter Email",
//                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
//                              borderSide: BorderSide(color: Colors.black),),
//                          ),),
//                        SizedBox(height: 16,),
//                        Text('  Mobile', style: TextStyle(fontSize: 18),),
//                        SizedBox(height: 10,),
//                        TextFormField(textAlign: TextAlign.center,
//                          style: TextStyle(fontSize: 20.0, color: Colors.black87),
//                          cursorColor: Colors.black87,
//                          controller: _mobileController,
//                          validator: validateMobile,
//                          decoration: InputDecoration(
//                            contentPadding: EdgeInsets.fromLTRB(20.0, 8.6, 20.0, 8.6),
//                            hintText: "Enter Mobile",
//                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
//                              borderSide: BorderSide(color: Colors.black),),
//                          ),),
//                        SizedBox(height: 20,),
//                        Row(mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Material(color: AppTheme.redColor,
//                              borderRadius: BorderRadius.circular(10.0),
//                              child: MaterialButton(
//                                minWidth: MediaQuery.of(context).size.width * 0.7,
//                                padding: EdgeInsets.fromLTRB(20.0, 11.0, 20.0, 11.0),
//                                child: Text("Submit", textAlign: TextAlign.center,
//                                  style: TextStyle(fontSize: 20.0).copyWith(
//                                    color: Colors.white, fontWeight: FontWeight.bold)),
//                                onPressed: _doEditProfile,
//                              ),
//                            ),
//                          ],
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//
//  _showAlertAndGoBack() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: new Text('Update Successful'),
//          content: new Text('User details has been updated successfully.'),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Okay", style: TextStyle(color: AppTheme.redColor),),
//              onPressed: () {
//                Navigator.of(context).pop();
//                Navigator.pop(context, [_nameController.text, _emailController.text,
//                  _mobileController.text]);
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
//
//  _showAlert(String title, String message) {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: new Text(title),
//          content: new Text(message),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Okay", style: TextStyle(color: AppTheme.redColor),),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
//
//
//}
