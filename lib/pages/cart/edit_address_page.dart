import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kakaji/models/arealist.dart';
import 'package:kakaji/models/citylist.dart';
import 'package:kakaji/utils/apptheme.dart';
import 'package:kakaji/utils/connection.dart';

class EditAddressPage extends StatefulWidget {
  final int addressId;
  final String house, pinCode, state, landmark, name, mobile;
  EditAddressPage({this.addressId, this.house, this.pinCode, this.state,
      this.landmark, this.name, this.mobile});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
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

  _editAddress() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('${_houseController.text}, ${_pinCodeController.text}, ${_stateController.text}, '
          ' ${_landmarkController.text}, ${_nameController.text}, '
          '${_mobileController.text}, ${widget.addressId} ' );
      if (_cityId == 0) {
        _showAlert('Alert', 'Please select city.');
        return;
      }
      if (_areaId == 0) {
        _showAlert('Alert', 'Please select area.');
        return;
      }
      print('city $_cityId and area $_areaId');
      var response = await http.post(Connection.addressEdit, body: {
        'address_id': '${widget.addressId}',
        'house_no': '${_houseController.text}',
        'pincode': '${_pinCodeController.text}',
        'city': '$_cityId',
        'area': '$_areaId',
        'state': '${_stateController.text}',
        'landmark': '${_landmarkController.text}',
        'name': '${_nameController.text}',
        'mobile': '${_mobileController.text}',
        'mobile1': '',
        'address_type': _isHome ? 'Home' : 'Work'
      });
      var decodedData = json.decode(response.body);
      print('decoded ==>> $decodedData');
      if (decodedData['status'] == true) {
        _showAlertAndPop('Address Updated', 'Address updated successfully.');
      } else {
        _showAlert('Update Failed', 'Failed to update address. Please try again later.');
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCityList();
    _houseController.text = widget.house;
    _pinCodeController.text = widget.pinCode;
    _stateController.text = widget.state;
    _landmarkController.text = widget.landmark;
    _nameController.text = widget.name;
    _mobileController.text = widget.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 1.0,
        title: Text('Edit Address'),),
      body: Form(autovalidate: _autoValidate,
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Theme(data: ThemeData(primaryColor: AppTheme.redColor),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _houseController,
                      validator: validateRequired,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0, color: Colors.black87),
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 11.0, 20.0, 11.0),
                        hintText: "House No. Building Name",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),),
                      ),),
                    SizedBox(height: 15,),
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
                  ],
                ),
              ),
            ),
            Container(color: Color(0xFFF1F1F1), height: 42, width: double.infinity,
              child: Align(alignment: Alignment.centerLeft,
                child: Padding(padding: const EdgeInsets.only(left: 20),
                  child: Text('CONTACT DETAILS',
                    style: TextStyle(fontWeight: FontWeight.w600,
                        fontSize: 17),),),
              ),),
            SizedBox(height: 20,),
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
            Container(color: Color(0xFFF1F1F1), height: 42, width: double.infinity,
              child: Align(alignment: Alignment.centerLeft,
                child: Padding(padding: const EdgeInsets.only(left: 20),
                  child: Text('ADDRESS TYPE',
                    style: TextStyle(fontWeight: FontWeight.w600,
                        fontSize: 17),),),
              ),),
            SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Address Type :-', style: TextStyle(fontSize: 18),),
                ToggleButtons(selectedColor: AppTheme.redColor,
                  fillColor: Color(0x33AA0315),
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.all(10.0),
                      child: Text('Home', style: TextStyle(fontSize: 18),),),
                    Padding(padding: const EdgeInsets.all(10.0),
                      child: Text('Work', style: TextStyle(fontSize: 18),),),
                  ],
                  onPressed: (int i) {
                    setState(() {
                      for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                        if (buttonIndex == i) {
                          _isHome = true;
                          isSelected[buttonIndex] = true;
                        } else {
                          _isHome = false;
                          isSelected[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  isSelected: isSelected,
                ),
              ],
            ),
            SizedBox(height: 20,),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 18),
              child: RaisedButton(color: AppTheme.redColor,
                child: Text('DELIVER HERE', style: TextStyle(color: Colors.white),),
                onPressed: _editAddress,
              ),
            ),
          ],
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
