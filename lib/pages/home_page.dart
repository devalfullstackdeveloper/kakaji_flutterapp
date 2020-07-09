import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:kakaji/main.dart';
import 'package:kakaji/pages/cart/cart_page.dart';
import 'package:kakaji/pages/profile/Aboutus.dart';
import 'package:kakaji/pages/profile/FAQ.dart';
import 'package:kakaji/pages/profile/FavouriteList.dart';
import 'package:kakaji/pages/search/Searchbar.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakaji/models/main_category.dart';
import 'package:kakaji/models/product.dart';
import 'package:kakaji/models/subcategory.dart';
import 'package:kakaji/pages/contactus_page.dart';
import 'package:kakaji/models/banners.dart';
import 'package:kakaji/pages/login/login_page.dart';
import 'package:kakaji/pages/product_details_page.dart';
import 'package:kakaji/pages/product_list_page.dart';
import 'package:kakaji/pages/profile/edit_profie_page.dart';
import 'package:kakaji/pages/profile/order_history_page.dart';
import 'package:kakaji/utils/apptheme.dart';
import 'package:kakaji/utils/connection.dart';
import 'package:kakaji/utils/custom_stepper.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'SubcategoryList.dart';
import 'profile/Contactus.dart';
import 'profile/NoInternet.dart';
import 'profile/PrivacyPolicy.dart';
import 'profile/TermConditions.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int userId = 0;
  String fullName, email;

  List<String> _fruitProducts = [];
  List _fruitSalePrices = [];
  List _fruitPacks = [];
  List _fruitMrps = [];

  List<String> _vegProducts = [];
  List _vegSalePrices = [];
  List _vegPacks = [];
  List _vegMrps = [];

  _getUserDetails() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = _prefs.getInt("user_id") ?? 0;
      fullName = _prefs.getString("fname") ?? '';
      email = _prefs.getString("email") ?? '';
      print('user id is $userId');
    });
  }

  Future<List<Banners>> _allBanners;
  Future<List<Banners>> _getBanners() async {
    var response = await http.post(Connection.banners,);
    var decodedData = json.decode(response.body);
    List<Banners> _banners = [];
    for (var i in decodedData) {
      Banners a = Banners(id: i["id"], name:i["name"], image: i["image"],link: i['link'],
          sortorder: i["sortorder"]);
      _banners.add(a);
    }
    return _banners;
  }

  Future<List<Product>> _allSubCategories;
  Future<List<Product>> _bestOffers;
  Future<List<Product>> _getBestOffers() async {
    var response = await http.post(Connection.bestOffer,body: {
    });

    var decodedData = json.decode(response.body);
    var webresp = decodedData['data'];
    print("daya $webresp");
    List<Product> _bestOffersList = [];
    for (var i in webresp) {
      Product a = Product(id: i["id"], name:i["name"], description: i["description"],
          qty_price: i["qty_price"], imageName: i["image"],mrps: i['mrp'],saleps:i['salep']
          ,buy1: i['buy1'],buy2: i['buy2'],buy3: i['buy3'],get1: i['get1'],get2: i['get2'],get3: i['get3'],
        option1:i['option1'],option2:i['option2'],option3:i['option3'],option4:i['option4'],description1:i['description1'],detail:i['detail']
      );
      _bestOffersList.add(a);
    }
    print('sub categs ${_bestOffersList.length}');
    return _bestOffersList;
  }
  Future<List<Product>> _getSubCategories() async {
    var response = await http.post(Connection.offer,body: {
    });

    var decodedData = json.decode(response.body);
    var webresp = decodedData['data'];
    print("daya $webresp");
    List<Product> _subCategories = [];
    for (var i in webresp) {
      Product a = Product(id: i["id"], name:i["name"], description: i["description"],
          qty_price: i["qty_price"], imageName: i["image"],mrps: i['mrp'],saleps:i['salep']
          ,buy1: i['buy1'],buy2: i['buy2'],buy3: i['buy3'],get1: i['get1'],get2: i['get2'],get3: i['get3'],
        option1:i['option1'],option2:i['option2'],option3:i['option3'],option4:i['option4'],description1:i['description1'],detail:i['detail']
      );
      _subCategories.add(a);
    }
    print('sub categs ${_subCategories.length}');
    return _subCategories;
  }
  List<MainCategory> _mainCategoriess = [];

  Future<List<MainCategory>> _allMainCategories;
  Future<List<MainCategory>> _getMainCategories() async {
    var response = await http.post(Connection.mainCategory,);
    var decodedData = json.decode(response.body);
    print('respone ${decodedData['data']}');
    var webresp = decodedData['data'];
    for (var i in webresp) {
      MainCategory a = MainCategory(id: i["id"], title: i["title"],
        mobileImage: i["mobileImage"], sort_order: i["sort_order"], status: i['status']);
           _mainCategoriess.add(a);
     }
    return _mainCategoriess;
   }

  Future<List<Product>> _allFruits;
  Future<List<Product>> _getFruits() async {
    var response = await http.post(Connection.productList, body: {
      'child_id': ''
    });
    var decodedData = json.decode(response.body);
    var webresp = decodedData['data'];
    List<Product> _productsList = [];
    for (var i in webresp) {
      Product a = Product(id: i["id"], name:i["name"], description: i["description"],
          qty_price: i["qty_price"], imageName: i["imageName"]);
      _productsList.add(a);
    }
    setState(() {
      for (int j=0; j<_productsList.length; j++) {
        _fruitProducts.add(_productsList[j].qty_price[0]['packtitle']);
        _fruitSalePrices.add(_productsList[j].qty_price[0]['salep']);
        _fruitMrps.add(_productsList[j].qty_price[0]['mrp']);
        _fruitPacks.add(_productsList[j].qty_price[0]['pack']);
      }
    });
    return _productsList;
  }

  Future<List<Product>> _allVegetables;
  Future<List<Product>> _getVegetables() async {
    var response = await http.post(Connection.productList, body: {
      'child_id': '7'
    });
    var decodedData = json.decode(response.body);
    var webresp = decodedData['data'];
    List<Product> _productsList = [];
    for (var i in webresp) {
      Product a = Product(id: i["id"], name:i["name"], description: i["description"],
          qty_price: i["qty_price"], imageName: i["imageName"]);
      _productsList.add(a);
    }
    setState(() {
      for (int j=0; j<_productsList.length; j++) {
        _vegProducts.add(_productsList[j].qty_price[0]['packtitle']);
        _vegSalePrices.add(_productsList[j].qty_price[0]['salep']);
        _vegMrps.add(_productsList[j].qty_price[0]['mrp']);
        _vegPacks.add(_productsList[j].qty_price[0]['pack']);
      }
    });
    return _productsList;
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

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _checkinternet();
    _allBanners = _getBanners();
    _allSubCategories = _getSubCategories();
    _allMainCategories = _getMainCategories();
    _allFruits = _getFruits();
    _allVegetables = _getVegetables();
    _bestOffers = _getBestOffers();
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

    //  _showAlertnointernet('Alert', 'No Internet Connection0');
    }
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => NoInternet()));
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.5,
        centerTitle: true,
        title:
        Image.asset('assets/kakalogo.png',height: 50,),
        //Text("Kakaji Store",style: TextStyle(fontWeight: FontWeight.bold,),),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c) => CartPage()));
              print("tapssss");
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10,right: 15),
              child: Icon(Icons.add_shopping_cart,color: Colors.black,size: 26,),
            ),
          ),
        ],
      ),
      drawer: _myDrawer(),
      body: ListView(
        children: <Widget>[
        Container(
          height:60,
          color: AppTheme.redColor,
          child: Padding(

            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                print("tapsss;");
              },
              child: TextField(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c) => Searchbar()));

                  print("tapsss;");
                },
              readOnly: true,
       // controller: _controller,
                //enableInteractiveSelection: false, // will disable paste operation
               // focusNode: new AlwaysDisabledFocusNode(),
              style: new TextStyle(
                height: 2.7,
                color: Colors.white,
              ),
              decoration: new InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  prefixIcon: new Icon(Icons.search, color: Colors.grey),
                  hintText: "Search...",
                  hintStyle: new TextStyle(color: Colors.grey)),
              ),
            ),
          ),
        ),
          SizedBox(height: 4,),
          _carousalSlider(),
          SizedBox(height: 4,),
          Image.asset('assets/shopbycategory.png', height: 50,fit: BoxFit.cover,),
          _mainCategories(),
         // Image.asset('assets/booksbnner.jpg', height: 75,fit: BoxFit.cover,),
          SizedBox(height: 6,),
          Image.asset('assets/bestoffers.png', height: 50,fit: BoxFit.cover,),
          SizedBox(height: 6,),
          _subCategories(),
          SizedBox(height: 6,),
          Image.asset('assets/bestproducts.png', height: 50,fit: BoxFit.cover,),
          SizedBox(height: 6,),
          _BestProductsFuture(),
          SizedBox(height: 6,),


//          _fruits(),
//          SizedBox(height: 16,),
//          _vegetables(),
//          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Drawer _myDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          userId == 0 ?
          SizedBox(height: 100,) :
          GestureDetector(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff2c3e50),
              ),
              accountName: Text("$fullName", style: TextStyle(color: Colors.white),),
              accountEmail: Text("$email", style: TextStyle(color: Colors.white),),
/*
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 3, color: Colors.white60),
                  image: DecorationImage(fit: BoxFit.contain,
                    image: AssetImage('assets/avatar.png'),
                  ),
                ),
              ),
*/
            ),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (c)=>EditProfilePage()));
            },
          ),
          SizedBox(height: 40,
            child: ListTile(
              leading: Icon(Icons.person),
              title: Align(alignment: Alignment(-1.3, 0),
                  child: Text("Edit Profile",)),
              onTap: () {
                userId == 0 ?
                _showLoginDialog('Login Required', 'You must login to edit profile.') :
                Navigator.push(context, MaterialPageRoute(builder: (c) =>
                    EditProfilePage()));
              },
            ),
          ),
          SizedBox(height: 40,
            child: ListTile(
              leading: Icon(Icons.favorite),
              title: Align(alignment: Alignment(-1.3, 0),
                  child: Text("WishList")),
              onTap: () {

                Navigator.push(context, MaterialPageRoute(builder: (c) =>
                    FavouriteList()));
              },
            ),
          ),
          SizedBox(height: 40,
            child: ListTile(
              leading: Icon(Icons.category),
              title: Align(alignment: Alignment(-1.3, 0),
                  child: Text("Catgeory")),
              onTap: () {
              },
            ),
          ),
          SizedBox(height: 380,
            child:ListView.builder
              (
                itemCount: _mainCategoriess.length,
                itemBuilder: (BuildContext ctxt, int index) {
               //   print("main category ${_mainCategoriess[index].title}");
                  return Column(
                    children: <Widget>[
                      new ListTile(
                        leading: Icon(Icons.arrow_forward),
                        title: Align(alignment: Alignment(-1.2, 0),
                            child: Text("${_mainCategoriess[index].title}")),
                        onTap: () {
                        //  Share.share('http://kakajistore.in/kakaji');
                          Navigator.push(context, MaterialPageRoute(builder: (c) =>
                              SubcategoryList(_mainCategoriess[index].id,_mainCategoriess[index].title)));
                        },
                      ),
                      Divider(color: Colors.grey,),
                    ],
                  );
                }
            ),
          ),
          SizedBox(height: 40,
            child: ListTile(
              leading: Icon(Icons.history),
              title: Align(alignment: Alignment(-1.3, 0),
                  child: Text("Order History")),
              onTap: () {
                userId == 0 ?
                _showLoginDialog('Login Required', 'You must login to view order history.') :
                Navigator.push(context, MaterialPageRoute(builder: (c) =>
                    OrderHistoryPage()));
              },
            ),
          ),
          SizedBox(height: 40,
            child: ListTile(
              leading: Icon(Icons.share),
              title: Align(alignment: Alignment(-1.2, 0),
                  child: Text("Share")),
              onTap: () {
                Share.share('http://kakajistore.in/kakaji');
              },
            ),
          ),
          Divider(color: Colors.grey,),
          SizedBox(height: 40,
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Align(alignment: Alignment(-1.3, 0),
                  child: Text("Contact Us")),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => Contactus()));
              },
            ),
          ),
          SizedBox(height: 40,
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Align(alignment: Alignment(-1.3, 0),
                  child: Text("About Us")),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => Aboutus()));
              },
            ),
          ),
          SizedBox(height: 40,
            child: ListTile(
              leading: Icon(Icons.security),
              title: Align(
                alignment: Alignment(-1.3, 0),
                child: Text("Privacy Policy")),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
//                _webViewPage("",
//                    "Privacy Policy");PrivacyPolicy
                Navigator.push(context, MaterialPageRoute(builder: (c) => PrivacyPolicy()));
              },
            ),
          ),
          SizedBox(height: 40,
            child: ListTile(
              leading: Icon(Icons.description),
              title: Align(
                alignment: Alignment(-1.5, 0),
                child: Text("Terms And Conditions")),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.push(context, MaterialPageRoute(builder: (c) =>
                    TermCondition()));
              },
            ),
          ),
          SizedBox(height: 40,
            child: ListTile(
              leading: Icon(Icons.help_outline),
              title: Align(
                alignment: Alignment(-1.2, 0),
                child: Text("FAQs")),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => FAQ()));

                FocusScope.of(context).requestFocus(FocusNode());

              },
            ),
          ),
          userId != 0 ? SizedBox() :
          ListTile(title: Text("Login"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }

  Widget _carousalSlider() {
    return FutureBuilder(
      future: _allBanners,
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return Container(
            height: 150,
            color: Colors.grey.withOpacity(.4),
          );
        } else {
          if (s.hasError) {
            return Container(
              height: 150,
              color: Colors.grey.withOpacity(.4),
            );
          } else {
            return CarouselSlider.builder(
              height: 150, viewportFraction: 1.0, aspectRatio: 0.3,
              autoPlay: true, enlargeCenterPage: true,
              itemCount: s.data.length,
              itemBuilder: (c, i) {

                return GestureDetector(
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (c) =>
                        SubcategoryList(s.data[i].link,s.data[i].name)));


                    },
                  child: Image.network('${s.data[i].image}',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,),
                );
              });
          }
        }
      },
    );
  }

  Widget _BestProductsFuture() {
    return FutureBuilder(
      future: _bestOffers,
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 3
            ),
            itemCount: 6,
            itemBuilder: (c, i) {
              return Container(color: AppTheme.separatorColor,);
            });
        } else {
          if (s.hasError || s.data.isEmpty) {
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 3
              ),
              itemCount: 6,
              itemBuilder: (c, i) {
                return Container(color: AppTheme.separatorColor,);
              });
          } else {
            return Container(
              height: 250,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: s.data.length,
                  //itemCount:s.data.length,
                  itemBuilder: (c, i) {
                   // print("imageName ${s.data[i].imageName}");
                    return _bestOffersItem(s,i);



                  }),
            );
          }
        }
      },
    );
  }
  Widget _bestOffersItem(AsyncSnapshot s, int i) {
    var img = jsonDecode(s.data[i].imageName);
    print("imagesss $img");
    var pcalculate =  s.data[i].saleps * 100 /  int.parse(s.data[i].mrps);
    var percent = 100 - pcalculate.toInt();
    print("percent  $percent");
    print("s.data[i].buy1 ${s.data[i].buy1}");

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 260,
          decoration: BoxDecoration(
            border: Border.all(width: 0.1,),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(

                children: <Widget>[
                  //  SizedBox(),
                  (s.data[i].buy1 != null || s.data[i].buy1 !=  null || s.data[i].buy3 != null)? Container(
                      color: AppTheme.yellowofferColor,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text('Offer',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      )) :SizedBox(),
                ],
              ),
              Column(mainAxisAlignment: MainAxisAlignment.start,
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
                       ],
                     ),
                     (s.data[i].mrps.toString() == s.data[i].saleps.toString())? SizedBox():
                     Positioned(
                       left: 0,
                       top: 0,
                       child: new Container(
                         width: 35.0,
                         height: 35.0,
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
                                   AppTheme.redColor,AppTheme.redColor,
                                 ])),
                         child: Center(
                           child: new Text("$percent%",
                               overflow: TextOverflow.ellipsis,
                               style: new TextStyle(
                                   color: Colors.white,

                                   fontSize:
                                   8.0)),
                         ), // You can add a Icon instead of text also, like below.
                         //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                       ), //............
                     ),
                   ],
                  ),
                  SizedBox(height: 10,),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      width: 150,
                      child: Text('${s.data[i].name}', maxLines: 2, style: TextStyle(letterSpacing: 0.5,
                          fontSize: 15, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,),
                    ),
                  ),
                  SizedBox(height: 10,),

                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (s.data[i].mrps.toString() == s.data[i].saleps.toString())? SizedBox() :
                      Text('MRP: ${s.data[i].mrps}', maxLines: 2, style: TextStyle(
                          fontFamily: 'WorkSans', decoration: TextDecoration.lineThrough,
                          fontSize: 15,color: Colors.grey),
                        textAlign: TextAlign.left,),
                      SizedBox(width: 9,),
                      Text('Buy: ₹ ${s.data[i].saleps}', maxLines: 2, style: TextStyle(
                          fontFamily: 'WorkSans',color: AppTheme.redColor,
                          fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) =>
            ProductDetailsPage(product: s.data[i],)));
      },
    );
  }

  Widget _subCategories() {
    return FutureBuilder(
      future: _allSubCategories,
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 3
            ),
            itemCount: 6,
            itemBuilder: (c, i) {
              return Container(color: AppTheme.separatorColor,);
            });
        } else {
          if (s.hasError || s.data.isEmpty) {
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 3
              ),
              itemCount: 6,
              itemBuilder: (c, i) {
                return Container(color: AppTheme.separatorColor,);
              });
          } else {
            return Container(
              height: 250,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: s.data.length,
                  //itemCount:s.data.length,
                  itemBuilder: (c, i) {
                   // print("imageName ${s.data[i].imageName}");
                    return  _productGridItem(s,i);
                  }),
            );

          }
        }
      },
    );
  }
  Widget _productGridItem(AsyncSnapshot s, int i) {
    var img = jsonDecode(s.data[i].imageName,);
    print("imagesss $img");

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 260,
          decoration: BoxDecoration(
            border: Border.all(width: 0.1,),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                    //  SizedBox(),
                  (s.data[i].buy1 != null || s.data[i].buy1 !=  null || s.data[i].buy3 != null)? Container(
                      color: AppTheme.yellowofferColor,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text('Offer',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      )) :SizedBox(),
                ],
              ),
              Column(
                children: <Widget>[
                 // SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeInImage.assetNetwork(
                        placeholder: "assets/loader.gif",
                        image: '${Connection.imagePath}/${img[0]}', height: 120, width: 120,
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      width: 150,
                      child: Text('${s.data[i].name}', maxLines: 2, style: TextStyle(letterSpacing: 0.5,
                          fontSize: 15, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (s.data[i].mrps.toString() == s.data[i].saleps.toString())? SizedBox() :
                      Text('MRP: ${s.data[i].mrps}', maxLines: 2, style: TextStyle(
                          fontFamily: 'WorkSans', decoration: TextDecoration.lineThrough,
                          fontSize: 15,color: Colors.grey),
                        textAlign: TextAlign.left,),
                      SizedBox(width: 9,),
                      Text('Buy: ₹ ${s.data[i].saleps}', maxLines: 2, style: TextStyle(
                          fontFamily: 'WorkSans',color: AppTheme.redColor,
                          fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                    ],
                  ),
//            Container(width: 150, height: 25,
//              decoration: BoxDecoration(
//                border: Border.all(width: 0.5,color: Colors.grey),
//              ),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Flexible(
//                    child: DropdownButtonHideUnderline(
//                      child: ButtonTheme(
//                        alignedDropdown: true,
//                        child: DropdownButton<String>(
//                          itemHeight: 55, isExpanded: true,
//                          hint: Text('Quantity',),
//                          value: _products[i],
//                          items: _allProduct.map((value) {
//                            return DropdownMenuItem<String>(
//                              value: value['packtitle'],
//                              child: Text(value['packtitle'], maxLines: 5,),
//                            );
//                          }).toList(),
//                          onChanged: (v) {
//                            List<String> pt = [];
//                            List<String> ms = [];
//                            List<String> sal = [];
//                            List<String> pc = [];
//                            setState(() {
//                              print('product ${_products[i]} chsnged value $v');
//                              _products[i] = v;
//                              print("object ${_allProduct[0]['packtitle']}");
//                              for(var i in _allProduct) {
//                                print("packtitle ${i['packtitle']}");
//                                var packtitle = i['packtitle'];
//                                var salep = i['salep'];
//                                var mr =  i['mrp'];
//                                var pck= i['pack'];
//                                pt.add(packtitle);
//                                ms.add(salep);
//                                sal.add(mr);
//                                pc.add(pck);
//                              }
//                              print("index of packtitle${pt.indexOf("${_products[i]}")}");
//                              int indx = pt.indexOf("${_products[i]}");
//                              setState(() {
//                                _salePrices[i] = ms[indx];
//                                _mrps[i] = sal[indx];
//                                _packs[i] = pc[indx];
//                              });
//                            });
//                          },
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            Text('MRP: ${s.data[i].mrp}', maxLines: 2, style: TextStyle(
//                fontFamily: 'WorkSans', decoration: TextDecoration.lineThrough,
//                fontSize: 15,color: Colors.grey),
//              textAlign: TextAlign.left,),
//            Text('Buy: ₹ ${s.data[i].salep}', maxLines: 2, style: TextStyle(
//                fontFamily: 'WorkSans',
//                fontSize: 14, fontWeight: FontWeight.bold),
//              textAlign: TextAlign.left,),
//            _userId == 0 ?
//            GestureDetector(
//              child: ClipRRect(borderRadius: BorderRadius.circular(4),
//                child: Container(color: Colors.red, width: 90, height: 32,
//                  child: Center(child: Text('Add', style: TextStyle(color: Colors.white),),),
//                ),
//              ),
//              onTap: () {
//                _showLoginDialog('Login Required', 'You must login to add items to cart.');
//              },
//            ) :
//            AddToCart(productId: s.data[i].id, productPrice: _salePrices[i], pack: _packs[i],),
//            SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) =>
            ProductDetailsPage(product: s.data[i],)));
      },
    );
  }

  Widget _mainCategories() {
    return FutureBuilder(
      future: _allMainCategories,
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return GridView.builder(
            padding: EdgeInsets.all(12),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 1/ 1.58,
                crossAxisSpacing: 8
            ),
            itemCount: 2,
            itemBuilder: (c, i) {
              return Container(color: AppTheme.separatorColor,);
          });
        } else {
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / 1.2,

              ),
              itemCount: s.data.length,
              itemBuilder: (c, i) {

                print('s.data[i].mobileImage ${s.data[i].mobileImage}');
                return GestureDetector(
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FadeInImage.assetNetwork(
                          placeholder: "assets/loader.gif",
                          image: '${s.data[i].mobileImage}',
                          height: 100,
                          //width: 100,
                        ),
                      SizedBox(height: 4,),
                        Text("${s.data[i].title}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                      ],
                    ),
                  ),
                  onTap: () {
                    /*Navigator.push(context, MaterialPageRoute(builder: (c) =>
                        ProductListPage(categoryId: s.data[i].id, // s.data[i].id,
                          categoryName: s.data[i].title,)));*/
                    Navigator.push(context, MaterialPageRoute(builder: (c) =>
                        SubcategoryList(s.data[i].id,s.data[i].title)));
                  },
                );
            });
          }
      //  }
      },
    );
  }


  _showLoginDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
             FlatButton(
              child: Text("Cancel", style: TextStyle(color: Colors.green),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Login", style: TextStyle(color: Colors.green),),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(this.context,
                    MaterialPageRoute(builder: (c) => LoginPage()));
              },
            ),
          ],
        );
      },
    );
  }


}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}