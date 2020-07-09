import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kakaji/models/FavouriteListModel.dart';
import 'package:kakaji/pages/login/login_page.dart';
import 'package:kakaji/pages/profile/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakaji/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:kakaji/pages/product_details_page.dart';
import 'package:kakaji/utils/apptheme.dart';
import 'package:kakaji/utils/connection.dart';
import 'package:kakaji/utils/custom_stepper.dart';

class search_list_page extends StatefulWidget {

  final String keyword;
  search_list_page(this.keyword);

  @override
  _search_list_pageState createState() => _search_list_pageState();
}

class _search_list_pageState extends State<search_list_page> {
  bool _isGridView = true;
  int _userId = 0;
  List<String> _products = [];
  List _salePrices = [];
  List _packs = [];
  List _mrps = [];
  List<Product> _productsList = [];
  List<FavouriteListModel> _wishList = [];

  String sortBy = '';

  _checkUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _userId = _prefs.getInt('user_id') ?? 0;
    _getWishUser();

  }

 _getWishUser() async {
    print("inside get list $_userId");
    var response = await http.post(Connection.wishlist, body: {
      'user_id': '$_userId',

    });
    var decodedData = json.decode(response.body);
    for (var i in decodedData) {
      print("websaa ${i["id"]}");
      wishlist.add(i['id'].toString());
      FavouriteListModel a = FavouriteListModel(id: i["id"], name:i["name"], mrp: i['mrp'],salep:i['salep'],image: i['image']);
      _wishList.add(a);
    }
    print("priduc lenht ${_wishList.length}");
    return _wishList;

  }


  List<String> wishlist= [];
  Future<List<Product>> _allProductList;
  Future<List<Product>> _getProductList() async {
    var response = await http.post(Connection.search, body: {
      'keyword':'${widget.keyword}'
    });
    _productsList.clear();
    var decodedData = json.decode(response.body);
  //  var webresp = decodedData['data'];
    //print("decode data $webresp");
    if(!decodedData.isEmpty){


    for (var i in decodedData) {
      print("websaa $i");
      Product a = Product(id: i["id"], name:i["name"], description: i["description"],
          qty_price: i["qty_price"], imageName: i["image"],mrps: i['mrp'],saleps:i['salep']
          ,buy1: i['buy1'],buy2: i['buy2'],buy3: i['buy3'],get1: i['get1'],get2: i['get2'],get3: i['get3'],
          option1:i['option1'],option2:i['option2'],option3:i['option3'],option4:i['option4'],description1:i['description1'],detail:i['detail']
      );
      _productsList.add(a);
    }
    setState(() {
//      for (int j=0; j<_productsList.length; j++) {
////        _products.add(_productsList[j].qty_price[0]['packtitle']);
////        _salePrices.add(_productsList[j].qty_price[0]['salep']);
////        _mrps.add(_productsList[j].qty_price[0]['mrp']);
////        _packs.add(_productsList[j].qty_price[0]['pack']);
//      }
    });
    return _productsList;
    }
    else{
      _productsList.clear();
      return _productsList;
    }

  }
  Future<List<Product>> _wishlistadd(productid) async {
    print('inside wishlist ${_userId}   and ${productid} ');
    var response = await http.post(Connection.wishlistadd, body: {
      'user_id': '$_userId',
      'product': '${productid.toString()}',

    });
    var decodedData = json.decode(response.body);
    var webresp = decodedData['status'];
    print("decode data $webresp");

  }
  Future<List<Product>> _wishlistremove(productid) async {
    print('inside wishlist ${_userId}   and ${productid} ');
    var response = await http.post(Connection.wishlistremove, body: {
      'user_id': '$_userId',
      'product': '${productid.toString()}',

    });
    var decodedData = json.decode(response.body);
    var webresp = decodedData['status'];
    print("decode data $webresp");

  }

  @override
  void initState() {
    super.initState();
    _checkUser();
    _allProductList = _getProductList();
    //_getWishUser();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.5,
        centerTitle: true,
        title: Text('${widget.keyword}'),
      ),
      body: Column(
        children: <Widget>[
          Container(height: 50,
            child: Row(
              children: <Widget>[
                Flexible(flex: 2,
                  child: Container(height: 50,
//                    decoration: BoxDecoration(
//                      border: Border.symmetric(horizontal: BorderSide(width: 0.2),
//                          vertical: BorderSide(width: 0.2)),
//                    ),
                    child: Center(
                      child: IconButton(
                        icon: _isGridView ? Icon(Icons.list) :
                          Icon(Icons.border_all, size: 20,),
                        onPressed: () {
                          setState(() {
                            if (_isGridView) {
                              _isGridView = false;
                            } else {
                              _isGridView = true;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Flexible(flex: 4,
                  child: Container(height: 50,
//                    decoration: BoxDecoration(
//                      border: Border.symmetric(horizontal: BorderSide(width: 0.2),
//                          vertical: BorderSide(width: 0.2)),
//                    ),
                    child: Center(
                      child: FlatButton(
                        child: Text('SORT BY'),
                        onPressed: () {
                          _showSortByBottomSheet(context);
                        },
                      ),
                    ),
                  ),
                ),
                Flexible(flex: 4,
                  child: Container(height: 50,
//                    decoration: BoxDecoration(
//                      border: Border.symmetric(horizontal: BorderSide(width: 0.2),
//                          vertical: BorderSide(width: 0.2)),
//                    ),
                    child: Center(
                      child: FlatButton(
                        child: Text('REFINE'),
                        onPressed: () {
                          setState(() {
                            sortBy = '';

                            _getProductList();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
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
                    return Center(child: Text('No Products Founds.',
                      style: TextStyle(color: Colors.black87, fontSize: 18),),);
                  } else if (s.data.isEmpty) {
                    return Center(child: Text('No Products Found.',
                      style: TextStyle(color: Colors.black87, fontSize: 18),),);
                  } else {
                    return _isGridView ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1/1.2,
                      ),
                      itemCount: s.data.length,
                      itemBuilder: (c, i) {
                        return _productGridItem(s, i);
                      }) :
                      ListView.builder(
                        itemCount: s.data.length,
                        itemBuilder: (c, i) {
                          return _productListItem(s, i);
                      });
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
bool fav = false;
  Widget _productGridItem(AsyncSnapshot s, int i) {

    var pcalculate =  s.data[i].saleps * 100 /  int.parse(s.data[i].mrps);
    var percent = 100 - pcalculate.toInt();
    print("percent  $percent");

    var img = jsonDecode(s.data[i].imageName);

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
                   (wishlist.contains(s.data[i].id.toString()))? GestureDetector(
                       onTap: (){
                         _wishlistremove(s.data[i].id);
                         setState(() {
                           wishlist.remove(s.data[i].id.toString());
                           fav = false;
                         });
                       },
                       child: Icon(Icons.favorite,color: Colors.red,)): GestureDetector(
                       onTap: (){
                         _wishlistadd(s.data[i].id);

                         setState(() {
                           fav = true;
                           wishlist.add(s.data[i].id.toString());
                         });
                       },
                       child: Icon(Icons.favorite_border)),
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
                         width: .8,
                       ),
                       shape: BoxShape.circle,
                       // You can use like this way or like the below line
                       //borderRadius: new BorderRadius.circular(30.0),
                       gradient: LinearGradient(
                           begin: FractionalOffset.centerLeft,
                           end: FractionalOffset.centerRight,
                           colors: [
                             AppTheme.redColor, AppTheme.redColor
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
                (s.data[i].mrps.toString() == s.data[i].saleps.toString())? SizedBox() :
                Text('MRP: ${s.data[i].mrps}', maxLines: 2, style: TextStyle(
                    fontFamily: 'WorkSans', decoration: TextDecoration.lineThrough,
                    fontSize: 15,color: Colors.grey),
                  textAlign: TextAlign.left,),
                SizedBox(width: 9,),
                Text('Buy: ₹ ${s.data[i].saleps}', maxLines: 2, style: TextStyle(
                    fontFamily: 'WorkSans',
                    color: AppTheme.redColor,
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
      ),
      onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (c) =>
             ProductDetailsPage(product: s.data[i],)));
      },
    );
  }

  Widget _productListItem(AsyncSnapshot s, int i) {
    List _allProduct = s.data[i].qty_price;
    var img = jsonDecode(s.data[i].imageName);
    print("imagesss $img");
    print("s.data[i].salep ${s.data[i].saleps}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,),
      child: Container(
//        decoration: BoxDecoration(
//          border: Border.symmetric(vertical: BorderSide(width: 0.1)),
//        ),
        child: Row(
          children: <Widget>[

            FadeInImage.assetNetwork(
              placeholder: "assets/loader.gif",
              image: '${Connection.imagePath}/${img[0]}',
              height: 120, width: 120,),
            SizedBox(width: 5,),
            Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text('${s.data[i].name}', maxLines: 2, style: TextStyle(letterSpacing: 0.5,
                    fontSize: 15, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
//                SizedBox(height: 10,),
//                Column(crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Container(width: 150, height: 25,
//                      decoration: BoxDecoration(
//                        border: Border.all(width: 0.5,color: Colors.grey),
//                      ),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Flexible(
//                            child: DropdownButtonHideUnderline(
//                              child: ButtonTheme(
//                                alignedDropdown: true,
//                                child: DropdownButton<String>(
//                                  itemHeight: 55, isExpanded: true,
//                                  hint: Text('Quantity',),
//                                  value: _products[i],
//                                  items: _allProduct.map((value) {
//                                    return DropdownMenuItem<String>(
//                                      value: value['packtitle'],
//                                      child: Text(value['packtitle'], maxLines: 5,),
//                                    );
//                                  }).toList(),
//                                  onChanged: (v) {
//                                    List<String> pt = [];
//                                    List<String> ms = [];
//                                    List<String> sal = [];
//                                    List<String> pc = [];
//                                    setState(() {
//                                      print('product ${_products[i]} chsnged value $v');
//                                      _products[i] = v;
//                                      print("object ${_allProduct[0]['packtitle']}");
//                                      for(var i in _allProduct) {
//                                        print("packtitle ${i['packtitle']}");
//                                        var packtitle = i['packtitle'];
//                                        var salep = i['salep'];
//                                        var mr =  i['mrp'];
//                                        var pck= i['pack'];
//                                        pt.add(packtitle);
//                                        ms.add(salep);
//                                        sal.add(mr);
//                                        pc.add(pck);
//                                      }
//                                      print("index of "
//                                        "packtitle${pt.indexOf("${_products[i]}")}");
//                                      int indx = pt.indexOf("${_products[i]}");
//                                      setState(() {
//                                        _salePrices[i] = ms[indx];
//                                        _mrps[i] = sal[indx];
//                                        _packs[i] = pc[indx];
//                                      });
//                                    });
//                                  },
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                    SizedBox(height: 10,),
//                    _userId == 0 ?
//                    GestureDetector(
//                      child: ClipRRect(borderRadius: BorderRadius.circular(4),
//                        child: Container(color: Colors.red, width: 90, height: 32,
//                          child: Center(child: Text('Add',
//                            style: TextStyle(color: Colors.white),),),
//                        ),
//                      ),
//                      onTap: () {
//                        _showLoginDialog('Login Required',
//                            'You must login to add items to cart.');
//                      },
//                    ) :
//                    AddToCart(productId: s.data[i].id, productPrice: _salePrices[i],
//                      pack: _packs[i],),
//                  ],
//                ),
//                SizedBox(height: 10,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showSortByBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
         return SafeArea(
           child: Container(
             child: Wrap(
               children: <Widget>[
                 SizedBox(height: 8,),
                 ListTile(title: Text('SORT BY',
                   style: TextStyle(color: Colors.green, fontSize: 18),),),
                 ListTile(title: Text('Price - Low to High'),
                  onTap: () {
                    setState(() {
                      sortBy = 'LTOH';
                    //  _productsList.clear();
                      _getProductList();
                      Navigator.pop(context);
                    });
                  },),
                 ListTile(title: Text('Price - High to Low'),
                   onTap: () {
                     setState(() {
                       sortBy = 'HTOL';
                    //   _productsList.clear();
                       _getProductList();
                       Navigator.pop(context);
                     });
                   },),
                 ListTile(title: Text('Name - A to Z'),
                   onTap: () {
                     setState(() {
                       sortBy = 'ATOZ';
                      // _productsList.clear();
                       _getProductList();
                       Navigator.pop(context);
                     });
                   },),
                 ListTile(title: Text('Name - Z to A'),
                   onTap: () {
                     setState(() {
                       sortBy = 'ZTOA';
                       //_productsList.clear();
                       _getProductList();
                       Navigator.pop(context);
                     });
                   },),
               ],
             ),
           ),
         );
      });
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


class AddToCart extends StatefulWidget {
  final int productId;
  final String productPrice, pack;
  AddToCart({this.productId, this.productPrice, this.pack});

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  int c = 0;

  Future<bool> _addProductToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('q ${c + 1}, pid ${widget.productId}, price ${widget.productPrice},'
        ' pack ${widget.pack}');
    var response = await http.post(Connection.cartAdd, body: {
      'user_id' : '${prefs.getInt('user_id')}',
      'product': "${widget.productId}",
      'quantity': "${c + 1}",
      'price': "${widget.productPrice}",
      'package': '${widget.pack}',
    });
    var decodedData = json.decode(response.body);
    print('add cart status -> ${decodedData['status']}');
    return decodedData['status'];
  }

  Future<bool> _removeProductFromCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('removing ${c - 1}');
    print('pid ${widget.productId}, price ${widget.productPrice}, pack ${widget.pack}');
    var response = await http.post(Connection.cartChangeQty, body: {
      'user_id' : '${prefs.getInt('user_id')}',
      'product': "${widget.productId}${widget.pack}",
      'quantity': "${c - 1}",
      'price': "${widget.productPrice}",
      'package': '${widget.pack}',
    });
    var decodedData = json.decode(response.body);
    print('remove cart status -> ${decodedData['status']}');
    return decodedData['status'];
  }

  @override
  Widget build(BuildContext context) {
    return AddCartStepper(initialValue: c,
      onAdd: (int val) {
        _addProductToCart().then((i) {
          setState(() {
            if (i == true) {
              c += val;
            } else {
              _showAlert('Alert', 'Could not add product to cart.');
            }
          });
        });
      },
      onRemove: c <= 1 ? null : (int val) {
        _removeProductFromCart().then((i) {
          setState(() {
            if (i == true) {
              print('inside $c and $val');
              c += val;
            } else {
              _showAlert('Alert', 'Could not add product to cart.');
            }
          });
        });
      });
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
              child: new Text("Okay", style: TextStyle(color: Colors.green),),
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


