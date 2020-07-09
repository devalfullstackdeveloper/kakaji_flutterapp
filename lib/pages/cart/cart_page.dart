import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kakaji/pages/profile/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakaji/models/cart.dart';
import 'package:http/http.dart' as http;
import 'package:kakaji/pages/cart/checkout_page.dart';
import 'package:kakaji/pages/login/login_page.dart';
import 'package:kakaji/utils/apptheme.dart';
import 'package:kakaji/utils/connection.dart';
import 'package:kakaji/utils/custom_stepper.dart';

int subTotal, totalQuantity, total;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> _cartList = [];
  int minOrderAmount;

  Future<List<Cart>> _allCartList;
  Future<List<Cart>>  _getCartList() async {
    print("inside cart ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("prefs.getInt ${prefs.getInt("user_id")}");
    var response = await http.post(Connection.cartDetails, body: {
      'user_id' : '${prefs.getInt("user_id")}',
    });
    var decodedData = json.decode(response.body);
    var data =decodedData['data'];
    print("carts $data");
    setState(() {
      subTotal = data['subtotal'];
      totalQuantity = data['totalQuantity'];
      total = data['total'];
      minOrderAmount = int.parse(data['minOrderAmount']);
    });
    _cartList.clear();
    var cart = data['cart'];
    //print("cart $cart");
   // for(int i= 0;i<=cart.lenght;i++ ) {
      cart.forEach((k, v) {
        print("cartsssssss ${cart[k]['quantity']}");

        Cart c = Cart(cartId: cart[k]['id'],
            name: cart[k]['name'],
            price: cart[k]["price"],
            quantity: cart[k]['quantity'],
            attributes: cart[k]['attributes']);
        _cartList.add(c);
        return _cartList;
      });
   // }
    print('cart list $_cartList');
    return _cartList;
  }

  _cartRemove(String cartId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(Connection.cartRemove, body: {
      'user_id': '${prefs.getInt("user_id")}',
      'product': '$cartId',
    });
    var decodedData = json.decode(response.body);
    var data = decodedData['data'];
    setState(() {
      _cartList.clear();
      _getCartList();
    });
//    _cartList.clear();
//    setState(() {
//      subTotal = data['subtotal'];
//      totalQuantity = data['totalQuantity'];
//      total = data['total'];
//      var cart = data['cart'];
//      print('cart => $cart');
//      if (cart.isNotEmpty) {
//        cart.forEach((k,v) {
//          Cart c = Cart(cartId: cart[k]['id'], name: cart[k]['name'], price: cart[k]["price"],
//              quantity: cart[k]['quantity'], attributes:  cart[k]['attributes']);
//          _cartList.add(c);
//        });
//      }
//    });
  }

  @override
  void initState() {
    super.initState();
    _allCartList = _getCartList();
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
        title: Text('Cart'),
      ),
      body: ListView(
        children: <Widget>[
          _cartProductsList(),
        ],
      ),
    );
  }

  Widget _cartProductsList() {
    return FutureBuilder(
      future: _allCartList,
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return Container(height: 400,
            child: Center(
              child: CircularProgressIndicator(valueColor:
              AlwaysStoppedAnimation<Color>(AppTheme.redColor),)
            ),
          );
        } else {
          if (s.hasError) {
            return Container(height: 400,
              child: Center(child: Text('The Cart is empty',
                style: TextStyle(color: Colors.black87, fontSize: 18),),),
            );
          } else if (s.data.isEmpty) {
            return Container(height: 400,
              child: Center(
                  child: CircularProgressIndicator(valueColor:
                  AlwaysStoppedAnimation<Color>(AppTheme.redColor),)
              ),
            );
          } else {
            return Column(
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: s.data.length,
                  itemBuilder: (c, i) {
                     return _cartProductItem(s, i);
                  }),
                SizedBox(height: 20,),
                Container(height: 35, color: AppTheme.separatorColor,),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Total:', style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w600),),
                          Text('₹ $subTotal', style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w600),)
                        ],
                      ),
                      SizedBox(height: 25,),
                      OutlineButton(
                        child: SizedBox(height: 40.0,
                            child: Center(child: Text('Proceed to Checkout'))),
                        onPressed: () {
                          if (subTotal < minOrderAmount) {
                            _showAlert('Order Failed',
                              'Your minimum order amount should be more than ₹ $minOrderAmount.');
                            return;
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (c) =>
                            CheckoutPage()));
                        }),
                      SizedBox(height: 30,),
                    ],
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }


  Widget _cartProductItem(AsyncSnapshot s, int i) {
    List image = jsonDecode("${s.data[i].attributes['image']}");
    return Card(
      child: Row(mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(10.0),
            child: ClipRRect(borderRadius: BorderRadius.circular(4),
              child: Container(width: 90, height: 90,
                child: Image.network('${Connection.imagePath}${image[0]}',
                  fit: BoxFit.contain,),)),
          ),
          SizedBox(width: 20,),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 17,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text('${s.data[i].name}',
                        style: TextStyle(fontSize: 16,fontFamily: 'WorkSans',
                            fontWeight: FontWeight.w600),maxLines: 2,),
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.delete),
                      ),
                      onTap: () {
                        _cartRemove('${s.data[i].cartId}');
                      },),
                  ],
                ),
                SizedBox(height: 20,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Rs. ${s.data[i].price}', style: TextStyle(fontFamily: 'WorkSans',
                        fontSize: 15.6, color: Color(0xFF926F4E)),),
                    Padding(padding: const EdgeInsets.only(right: 10),
                      child: ChangeCartQuantity(productId: s.data[i].attributes['id'],
                        productPrice: s.data[i].price, cartId: s.data[i].cartId.toString(),
                        pack: s.data[i].attributes['package'],
                        quantity: s.data[i].quantity is String ?
                          int.parse(s.data[i].quantity) : s.data[i].quantity,
                        changeSubTotals: (newValue) {
                          setState(() {
                            subTotal = newValue[0];
                            totalQuantity = newValue[1];
                            total = newValue[2];
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ],
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

class ChangeCartQuantity extends StatefulWidget {
  final int quantity, productPrice, productId;
  final Function(List<int>) changeSubTotals;
  final String pack, cartId;
  ChangeCartQuantity({this.productId, this.productPrice, this.pack, this.quantity, this.cartId,
    this.changeSubTotals});

  @override
  _ChangeCartQuantityState createState() => _ChangeCartQuantityState();
}

class _ChangeCartQuantityState extends State<ChangeCartQuantity> {
  int c = 0;

  Future<bool> _addProductToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Add cart pid ${widget.productId}, price ${widget.productPrice}, pack ${widget.pack}');
    var response = await http.post(Connection.cartAdd, body: {
      'user_id' : '${prefs.getInt('user_id')}',
      'product': "${widget.productId}",
      'quantity': "${ 1}",
      'price': "${widget.productPrice}",
      'package': '${widget.pack}',
    });
    var decodedData = json.decode(response.body);
    print('add cart status -> ${decodedData['status']}');
    return decodedData['status'];
  }

  Future<bool> _removeProductFromCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Remove cart pid ${widget.productId}, price ${widget.productPrice}, '
        'pack ${widget.pack}');
    var response = await http.post(Connection.cartChangeQty, body: {
      'user_id' : '${prefs.getInt('user_id')}',
      'product': "${widget.cartId}",
      'quantity': "${ 1}",
      'price': "${widget.productPrice}",
      'package': '${widget.pack}',
    });
    var decodedData = json.decode(response.body);
    print('remove cart status -> ${decodedData['status']}');
    return decodedData['status'];
  }

  @override
  void initState() {
    super.initState();
    c = widget.quantity ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return CartChangeStepper(initialValue: c,
      onAdd: (int val) {
        _addProductToCart().then((i) {
          setState(() {
            if (i == true) {
              c += val;
              widget.changeSubTotals([
                subTotal + widget.productPrice,
                totalQuantity + 1,
                total + widget.productPrice
              ]);
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
              c += val;
              widget.changeSubTotals([
                subTotal - widget.productPrice,
                totalQuantity - 1,
                total - widget.productPrice
              ]);
            } else {
              _showAlert('Alert', 'Could not remove product from cart.');
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

