import 'dart:convert';
import 'dart:io';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakaji/pages/profile/Aboutus.dart';
import 'package:kakaji/pages/profile/PrivacyPolicy.dart';
import 'package:kakaji/pages/profile/TermConditions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakaji/main.dart';
import 'package:kakaji/pages/login/login_page.dart';
import 'package:kakaji/pages/profile/edit_profie_page.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter/material.dart';

import 'FavouriteList.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int id = 0;
  String fullName, email, phone, address;
  String base64Image = '';
  File _image;

  List<String> _profileDetailsList = ['Edit Profile','WishList' ,'About Us', 'Privacy Policy',
    'Terms & Conditions', 'Signout'];
  List<IconData> _profileDetailsIcons = [Icons.person,
    Icons.favorite,
    Icons.info_outline,
    Icons.security,
    Icons.description,
    Icons.exit_to_app
  ];

  _clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  _getUserDetails() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      id = _prefs.getInt("user_id") ?? 0;
      fullName = _prefs.getString("fname") ?? '';
      email = _prefs.getString("email") ?? '';
      phone = _prefs.getString("phone") ?? '';
      address = _prefs.getString("address") ?? '';
    });
  }

  Future<Null> _webViewPage(String url, String title) async {
    if (await url_launcher.canLaunch(url)) {
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => WebviewScaffold(
            initialChild: Center(
              child: CircularProgressIndicator(),
            ),
            url: url,
            appBar: AppBar(title: Text(title),),
          )));
    } else {
      Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Could not launch the url')));
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print("image path ${image.path}");
      List<int> imageBytes = image.readAsBytesSync();
      base64Image = base64Encode(image.readAsBytesSync());
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.5, centerTitle: true,
        title: Text('Profile',style: TextStyle(),),
      ),
      body: ListView(
        children: <Widget>[
/*
          Column(
            children: <Widget>[
              SizedBox(height: 25,),
              _image == null ?
              Center(
                child: Container(height: 120, width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.6),
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage('assets/avatar.png'),
                    ),
                  ),
                  child: Align(alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      child: Container(height: 30, width: 40,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15))
                        ),
                        child: Center(
                          child: Icon(Icons.camera,
                            color: Colors.white, size: 18,),
                        ),
                      ),
                      onTap: getImage,
                    ),
                  ),
                ),
              ) :
              Container(height: 120, width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.6),
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: FileImage(_image),
                    fit: BoxFit.cover
                  ),
                ),
                child: Align(alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    child: Container(height: 40, width: 50,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))
                      ),
                      child: Center(
                        child: Icon(Icons.camera,
                          color: Colors.white, size: 18,),
                      ),
                    ),
                    onTap: getImage,
                  ),
                ),
              ),
            ],
          ),
*/
          SizedBox(height: 30,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(height: 18.0, color: Colors.amber.shade500,),
                Text(' Name : $fullName',),
                Divider(height: 18.0, color: Colors.amber.shade500,),
                Text(' Mobile : $phone',),
                Divider(height: 18.0, color: Colors.amber.shade500,),
                Text(' Email : $email',),
                Divider(height: 18.0, color: Colors.amber.shade500,),
              ],
            ),
          ),
          SizedBox(height: 30,),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _profileDetailsIcons.length,
            itemExtent: 58,
            itemBuilder: (c, i) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(_profileDetailsIcons[i]),
                    title: Text('${_profileDetailsList[i]}'),
                    trailing: Icon(Icons.chevron_right,
                      color: Colors.grey,),
                    onTap: () {
                      switch (i) {
                        case 0:
                          _goProfileEdit();
                          break;
                          case 1:
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => FavouriteList()));
                           // FavouriteList();
                          break;
                        case 2:
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.push(context,
                              MaterialPageRoute(builder: (c) => Aboutus()));
                          break;
                        case 3:
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.push(context, MaterialPageRoute(builder: (c) => PrivacyPolicy()));

                          break;
                        case 4:
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.push(context, MaterialPageRoute(builder: (c) => TermCondition()));

                          break;
                        case 5:
                          _clearPrefs();
                           Navigator.pushReplacement(context,
                               MaterialPageRoute(builder: (c) => LoginPage()));
                          break;
                      }
                    },
                  ),
                  Divider(color: Colors.amber.shade500, height: 1,),
                ],
              );
            },
          ),

        ],
      ),
    );
  }

  _goProfileEdit() async {
    List<String> userDetails = await Navigator.push(context,
        MaterialPageRoute(builder: (c) => EditProfilePage()));
    if (userDetails.isNotEmpty) {
      fullName = userDetails[0];
      email = userDetails[1];
      phone = userDetails[2];
    }
  }


}
