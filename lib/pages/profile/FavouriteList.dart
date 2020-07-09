import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kakaji/models/FavouriteListModel.dart';
import 'package:kakaji/models/product.dart';
import 'package:kakaji/pages/product_details_page.dart';
import 'package:kakaji/pages/profile/NoInternet.dart';
import 'package:kakaji/utils/apptheme.dart';
import 'package:kakaji/utils/connection.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteList extends StatefulWidget {
  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  Future<List<Product>> _allProductList;
  List<Product> _productsList = [];
  int _userId = 0;

  Future<List<Product>> _getProductList() async {
    print("inside get list $_userId");
    var response = await http.post(Connection.wishlist, body: {
      'user_id': '$_userId',

    });
    var decodedData = json.decode(response.body);
    for (var i in decodedData) {
      print("websaa $i");
      Product a = Product(id: i["id"], name:i["name"], description: i["description"],
        qty_price: i["qty_price"], imageName: i["image"],mrps: i['mrp'],saleps:i['salep']
        ,buy1: i['buy1'],buy2: i['buy2'],buy3: i['buy3'],get1: i['get1'],get2: i['get2'],get3: i['get3'],
        option1:i['option1'],option2:i['option2'],option3:i['option3'],option4:i['option4'],description1:i['description1'],detail:i['detail']
      );
      _productsList.add(a);
    }
    print("priduc lenht ${_productsList.length}");
    return _productsList;

  }
  _checkUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = _prefs.getInt('user_id') ?? 0;
      _allProductList =   _getProductList();
    });

  }

  Future<List<Product>> _wishlistremove(productid) async {
    print('inside wishlist ${_userId}   and ${productid} ');
    var response = await http.post(Connection.wishlistremove, body: {
      'user_id': '$_userId',
      'product': '${productid.toString()}',

    });
    var decodedData = json.decode(response.body);
    var webresp = decodedData['status'];
    _productsList.clear();
    print("decode data $webresp");
    setState(() {
      _allProductList =  _getProductList();

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUser();
    _allProductList =  _getProductList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.5,
        centerTitle: true,
        title: Text('Wish List'),
      ),
      body:_favlistFuture(),
    );
  }

  _favlistFuture(){
    return FutureBuilder(
      future: _allProductList,
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return Center(
              child: CircularProgressIndicator(valueColor:
              AlwaysStoppedAnimation<Color>(AppTheme.redColor),
              )
          );
        } else {
          if (s.hasError) {
            return Center(child: Text('No Products Found.',
              style: TextStyle(color: Colors.black87, fontSize: 18),),);
          } else if (s.data.isEmpty) {
            return Center(child: Text('No Products Found.',
              style: TextStyle(color: Colors.black87, fontSize: 18),),);
          } else {
            return  GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1/1.2,
                ),
                itemCount: s.data.length,
                itemBuilder: (c, i) {
                  return _productGridItem(s, i);
                });
          }
        }
      },
    );
  }

  Widget _productGridItem(AsyncSnapshot s, int i) {
  //  List _allProduct = s.data[i].qty_price;
 //  var imgs = jsonEncode(s.data[i].image);
    print("imagesss ${s.data[i].imageName}");
    var pcalculate =  s.data[i].saleps * 100 /  int.parse(s.data[i].mrps);
    var percent = 100 - pcalculate.toInt();
    print("percent  $percent");

    var img =jsonDecode(s.data[i].imageName);
   print("imagesss ${s.data[i].imageName}");
    // var imagessss = img[0];
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.1,),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            SizedBox(height: 10,),
            Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInImage.assetNetwork(
                      placeholder: "assets/loader.gif",
                      image: '${Connection.imagePath}/${img[0]}', height: 120, width: 120,
                    ),
                    GestureDetector(
                        onTap: (){
                          _wishlistremove(s.data[i].id);
                        },
                        child: Icon(Icons.delete)),
                  ],
                ),
                (s.data[i].mrps.toString() == s.data[i].saleps.toString())? SizedBox():    Positioned(
                  left: 10,
                  top: 10,
                  child: new Container(
                    width: 40.0,
                    height: 40.0,
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 7),
                    //I used some padding without fixed width and height

                    decoration: new BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          //                   <--- border color
                          width: .8,
                        ),
                        shape: BoxShape.circle,
                        // You can use like this way or like the below line
                        //borderRadius: new BorderRadius.circular(30.0),
                        gradient: LinearGradient(
                            begin: FractionalOffset.centerLeft,
                            end: FractionalOffset.centerRight,
                            colors: [
                              Colors.orange,Colors.orange,
                            ])),
                    child: Center(
                      child: new Text("$percent%",
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              color: Colors.white,

                              fontSize:
                              12.0)),
                    ), // You can add a Icon instead of text also, like below.
                    //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                  ), //............
                ),
              ],
            ),
            SizedBox(height: 10,),

            Padding(padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text('${s.data[i].name}', maxLines: 2, style: TextStyle(letterSpacing: 0.5,
                  fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,),
            ),
            SizedBox(height: 10,),

            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (s.data[i].mrps.toString() == s.data[i].saleps.toString()) ? SizedBox() :
                Text('MRP: ${s.data[i].mrps}', maxLines: 2, style: TextStyle(
                    fontFamily: 'WorkSans', decoration: TextDecoration.lineThrough,
                    fontSize: 15,color: Colors.grey),
                  textAlign: TextAlign.left,),
                SizedBox(width: 9,),
                Text('Buy: ₹ ${s.data[i].saleps}', maxLines: 2, style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) =>
            ProductDetailsPage(product: s.data[i],)));
      },
    );
  }

}
