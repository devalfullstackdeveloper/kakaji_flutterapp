import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kakaji/models/order_history.dart';
import 'package:kakaji/pages/profile/NoInternet.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakaji/models/addresslist.dart';
import 'package:kakaji/pages/cart/add_address_page.dart';
import 'package:kakaji/pages/cart/edit_address_page.dart';
import 'package:kakaji/pages/profile/edit_profie_page.dart';
import 'package:kakaji/utils/apptheme.dart';
import 'package:kakaji/utils/connection.dart';
import '../../main.dart';

bool pickup = false;

class CheckoutPage extends StatefulWidget {

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Razorpay _razorPay;
  int userId;
  String fname, phone, email, address, city, postcode;
  int _currentValue;
  int _addressId;
  bool isExpressDelivery = false;
  int toPay = 0;
  int subTotal = 0;
  int shipping = 0;
  int shippingcost = 0;
  int expressCharge = 0;
  int expressChargess = 0;
  int penalty = 0;
var offer;
  _getCheckoutDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;
    print("iser id ${prefs.getInt('user_id')}");
    var response = await http.post(Connection.checkoutDetails, body: {
      'user_id': '$userId',
    });
    var decodedData = json.decode(response.body);
    print('checkout details = $decodedData');
    if (decodedData['status'] == true) {
      setState(() {
        subTotal = decodedData['data']['subtotal'];
        shipping = decodedData['data']['shipping'];
        shippingcost = decodedData['data']['shipping'];
        offer = decodedData['data']['offer'];
        penalty = decodedData['data']['penalty'];
        expressCharge = int.parse(decodedData['data']['expressCharge']);
        expressChargess = int.parse(decodedData['data']['expressCharge']);
      });
    }

  }
  List<dynamic> _addressids = [];

  Future<List<AddressList>> _getAllAddressList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;
    print('user id $userId');
    var response = await http.post(Connection.addressList, body: {
      'user_id': '$userId',
    });
    var decodedData = json.decode(response.body);
    List<AddressList> _addList = [];
    for (var i in decodedData) {
      AddressList al = AddressList(id: i['id'], user_id: i['user_id'],
          pincode: i['pincode'], house_no: i['house_no'], area: i['area'], city: i['city'],
          state: i['state'], landmark: i['landmark'], name: i['name'], mobile: i['mobile'],
          mobile1: i['mobile1'], address_type: i['address_type']);
      _addList.add(al);
      _addressids.add(i['id'].toString());
    }
    if (_addList.isNotEmpty) {
    //  _addressId = _addList[0].id;
    }
    return _addList;
  }

  _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("user_id") ?? 0;
      fname = prefs.getString("fname") ?? '';
      phone = prefs.getString("phone") ?? '';
      email = prefs.getString("email") ?? '';
      address = prefs.getString("address") ?? '';
      city = prefs.getString("city") ?? '';
      postcode = prefs.getString("postcode") ?? '';
    });
  }

  _checkout() async {
    print('$_addressId and $_sharedValue');
    String payment ="cod";
    if(_sharedValue == 0){
      payment = "cod";
    }else{
      payment ="pickup";
    }
    if(_addressId == null && payment == "pickup"){
      print("indifr sddredd id");
      _addressId = 0;
    }
    if(_addressId == null && payment == "cod"){
      print("indifr sddredd id ${_addressids[0]}");
      _addressId = int.parse(_addressids[0]);
    }




    print("userid $userId , addess id $_addressId payment $payment");

    var response = await http.post(Connection.cartCheckout, body: {
      'user_id': '$userId',
      'address_id': '$_addressId',
      'payref_id': '',
      'payment':'$payment'
    });
    var decodedData = json.decode(response.body);
    print('decodedData Checkout =>  $decodedData');
    if (decodedData['status'] == true) {
      _showAlertAndHome('Order Placed', 'Your Order has been placed successfully.');
    } else {
      _showAlert('Order Failed', 'Failed to place order. Please try again later.');
    }
  }

  @override
  void initState() {
    super.initState();
    _getCheckoutDetails();
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _getUserDetails();
    _currentValue = 0;
    _getAllAddressList();
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
  void dispose() {
    super.dispose();
    _razorPay.clear();
  }

  @override
  Widget build(BuildContext context) {

    print("offer $offer");
    return Scaffold(
      appBar: AppBar(elevation: 0.5,
        centerTitle: true,
        title: Text('Checkout'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: <Widget>[
          _personalDetails(),
          Container(height: 1.5, width: double.infinity,
              color: Colors.grey),

             SizedBox(height: 18,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total:', style: TextStyle(fontSize: 16),),
                Text('₹ $subTotal', style: TextStyle(fontSize: 16),),
              ],
            ),
          SizedBox(height: 18,),
          (penalty==0)?SizedBox():  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Penelty:', style: TextStyle(fontSize: 16),),
              Text('₹ $penalty', style: TextStyle(fontSize: 16),),
            ],
          ),
          SizedBox(height: 12,),
          ( pickup == false)?    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Shipping Cost:', style: TextStyle(fontSize: 16),),
              Text('₹ ${isExpressDelivery ? expressCharge : shipping}',
                style: TextStyle(fontSize: 16),),
            ],
          ) :SizedBox(),
          SizedBox(height: 6,),
          ( pickup == false)?   Row(mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(activeColor: AppTheme.redColor,
                value: isExpressDelivery,
                onChanged: (bool val) {
                  setState(() {
                    isExpressDelivery = val;
                  });
                },
              ),
               Text('Express Delivery: ₹ $expressCharge',
                style: TextStyle(fontSize: 16),)
            ],
          ) : SizedBox(),
          //offer
          (offer!=null)? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Offer', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600),),
                SizedBox(height: 8,),
              Container(
                height: 80,
                child:ListView.builder(
                    itemCount: offer.length,
                    itemBuilder: (c, i) {
                     return Text("${offer[i]} ");
                    }) ,
              ),
            ],
          ):SizedBox(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('To Pay:', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600),),
              _toPayAmount(),
            ],
          ),
          SizedBox(height: 15,),
          CupertinoSegmentedControl(
              borderColor: AppTheme.redColor,
              selectedColor: AppTheme.redColor,
              children: _titles,
              groupValue: _sharedValue,
              onValueChanged: (int v) {
                setState(() {
                  _sharedValue = v;
                    if(v ==1 ){
                      pickup = true;
                      expressCharge =0;
                      shipping =0;
                    }else{
                      pickup = false;
                      expressCharge =expressChargess;
                      shipping = shippingcost;
                    }
                  print("_sharedValue  $_sharedValue");
                });
              }
          ),
          SizedBox(height: 14,),
          Container(height: 1.5, width: double.infinity,
              color: Colors.grey),
          SizedBox(height: 12,),
          (_sharedValue == 1)?Container(width: double.infinity,
            child: RaisedButton(color: AppTheme.redColor,
              child: Text('PLACE ORDER', style: TextStyle(color: Colors.white),),
              onPressed:  _showAlerts,
            ),
          ) :
          Column(
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Select Address', style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w500),),
                  RaisedButton(color: AppTheme.redColor,
                    child: Text('ADD', style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) =>
                          AddAddressPage(userId: userId,)));
                    },
                  ),
                ],
              ),
              SizedBox(height: 8,),
              _addressList(),
            ],
          ),

        ],
      ),
    );
  }
  _showAlerts() {
    print("address id $_addressId");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are you Sure ?"),
          content: new Text("You want to place the order."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                _checkout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget _toPayAmount() {
    int shippingAmount = isExpressDelivery ? expressCharge : shipping;
    toPay = shippingAmount + subTotal + penalty;
    return Text('₹ $toPay', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600),);
  }

  _personalDetails() {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text('$fname', style: TextStyle(fontSize: 22,
                    fontWeight: FontWeight.w600),
                  maxLines: 3,),),
              IconButton(icon: Icon(Icons.edit, color: AppTheme.redColor,),
                onPressed: () async {
                  List<String> profileDetails = await Navigator.push(context,
                      MaterialPageRoute(builder: (c) =>
                          EditProfilePage()));
                  if (profileDetails.isNotEmpty) {
                    fname = profileDetails[0];
                    email = profileDetails[1];
                    phone = profileDetails[2];
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 8,),
          Text('Email:- $email', style: TextStyle(fontSize: 16,
              color: Colors.black87),),
          SizedBox(height: 8,),
          Text('Mobile:- $phone', style: TextStyle(fontSize: 15, color: Colors.black87),),
        ],
      ),
    );
  }

  Widget _addressList() {
    return FutureBuilder(
      future: _getAllAddressList(),
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(valueColor:
            AlwaysStoppedAnimation<Color>(AppTheme.redColor),),
          );
        } else {
          if (s.hasError) {
            return Container(height: 350, width: double.infinity,
              child: Center(
                child: Text('No Address found.',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 18,
                      fontWeight: FontWeight.w600),),
              ),);
          } else {
            return s.data.isEmpty ?
            Container(
              child: Center(
                child: Text('No Address found. Please add address',
                  style: TextStyle(color: Colors.grey, fontSize: 18),),
              ),
            )
            : Column(
              children: <Widget>[
              ListView.builder(shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0),
                itemCount: s.data.length,
                itemBuilder: (c, i) {
                  return RadioListTile(
                    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${s.data[i].name}', style: TextStyle(fontSize: 18),),
                        IconButton(icon: Icon(Icons.edit, color: AppTheme.redColor,),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (c) =>
                              EditAddressPage(
                                addressId: s.data[i].id,
                                pinCode: s.data[i].pincode,
                                house: s.data[i].house_no,
                                state: s.data[i].state,
                                landmark: s.data[i].landmark,
                                name: s.data[i].name,
                                mobile: s.data[i].mobile,
                              )));
                        },),
                      ],
                    ),
                    subtitle: Text('${s.data[i].house_no} ${s.data[i].area} '
                      '${s.data[i].city},'
                      ' ${s.data[i].landmark}, ${s.data[i].pincode}. - (M) '
                      '${s.data[i].mobile}'),
                    groupValue: _currentValue,
                    activeColor: AppTheme.redColor,
                    value: i,
                    onChanged: (val) {
                      setState(() {
                        _currentValue = val;
                        _addressId = s.data[_currentValue].id;
                        print('address id is $_addressId   " i:" $i' );
                      });
                    },
                  );
                }),
                SizedBox(height: 20,),
                Container(width: double.infinity,
                  child: RaisedButton(color: AppTheme.redColor,
                    child: Text('PLACE ORDER', style: TextStyle(color: Colors.white),),
                    onPressed:  _showAlerts,
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }

  int _sharedValue = 0;
  final Map<int, Widget> _titles = <int, Widget>{
    0: Text(' Cash On Delivery '),
    1: Text(' Pickup '),
  };

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("SUCCESS: " + response.paymentId);
    var webResponse = await http.post(Connection.cartCheckout, body: {
      'user_id': userId,
      'address_id': _addressId,
      'payref_id': response.paymentId,
    });
    var decodedData = json.decode(webResponse.body);
    print('decodedData $decodedData');
    if (decodedData['status'] == true) {
      _showAlertAndHome('Order Placed', 'Your Order has been placed successfully.');
    } else {
      _showAlert('Order Failed', 'Failed to place order. Please try again later.');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("FAILURE: " + response.code.toString() + " - " + response.message);
    _showAlert('Order Failed', 'Failed to place order. Please try again later.');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET: " + response.walletName);
  }

  _payOnline() async {
    int finalAmount = toPay * 100;
    var options = {
      'key': 'rzp_test_c2xp2kueSUjILt', // rzp_test_c2xp2kueSUjILt
      'amount': finalAmount,
      'name': 'Smile Karts',
      'description': 'Pay Online',
      'prefill': {'contact': '$phone', 'email': '$email'},
      'external': {
        'wallets': ['paytm']
      },
      'theme': {
        'color': '#84ba40'
      }
    };
    try {
      _razorPay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  // unused older razor_plugin
  _startPayment() async {
    int finalAmount = subTotal * 100;
    Map<String, dynamic> options = new Map();
    options.putIfAbsent("name", () => "Smile Karts");
    options.putIfAbsent("image", () =>
    "http://smilekarts.com/website/website/assets/images/icon/brand-logo/logo.png");
    options.putIfAbsent("description", () => "Pay Online");
    options.putIfAbsent("amount", () => "${finalAmount.toString()}");
    options.putIfAbsent("email", () => email);
    options.putIfAbsent("contact", () => phone);
    options.putIfAbsent("theme", () => "#84BA40");
    Map<String, String> notes = new Map();
    notes.putIfAbsent('key', () => "value");
    notes.putIfAbsent('randomInfo', () => "haha");
    options.putIfAbsent("notes", () => notes);
    options.putIfAbsent("api_key", () => "rzp_live_fIIeCo2mijBOQ8"); //  rzp_test_c2xp2kueSUjILt
    Map<dynamic, dynamic> paymentResponse = new Map();
//    paymentResponse = await Razorpay.showPaymentForm(options);
    print("response code ${paymentResponse['code']}");
    print("response message ${paymentResponse['message']}");

    if (paymentResponse['code'] == '1') {
      print('code ${paymentResponse['code']}');
      print('Continue to checkout');
      print('address id $_addressId');

      var response = await http.post(Connection.cartCheckout, body: {
        'user_id': userId,
        'address_id': _addressId,
        'payref_id': paymentResponse['message'],
      });
      var decodedData = json.decode(response.body);
      print('decodedData $decodedData');
      if (decodedData['status'] == true) {
        _showAlertAndHome('Order Placed', 'Your Order has been placed successfully.');
      } else {
        _showAlert('Order Failed', 'Failed to place order. Please try again later.');
      }
    } else {
      print('code ${paymentResponse['code']}');
      _showAlert('Payment Failed', 'Payment failed or cancelled by the user.');
    }
  }

  _showAlert(String title, String message) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("Okay", style: TextStyle(color: AppTheme.redColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showAlertAndHome(String title, String message) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("Okay", style: TextStyle(color: AppTheme.redColor),),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (c) =>
                    PageSelector()));
              },
            ),
          ],
        );
      },
    );
  }

}
