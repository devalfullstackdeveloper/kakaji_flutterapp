import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakaji/models/order_history.dart';
import 'package:kakaji/utils/apptheme.dart';
import 'package:kakaji/utils/connection.dart';
import 'history_product_details_page.dart';


class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  var cancel_charge;
  Future<List<OrderHistory>> _allOrderHistory;
  Future<List<OrderHistory>> _getOrderHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(Connection.productHistory, body: {
      'user_id' : '${prefs.getInt("user_id")}',
    });
    var decodedData = json.decode(response.body);
    print("decodedata $decodedData");
    var data = decodedData['data'];
     cancel_charge = decodedData['cancel_charge'];
    List<OrderHistory> _orderHistoryList = [];
    for (var i in data) {
      OrderHistory p = OrderHistory(order_id: i['order_id'], address: i['address'],penlaty: i['penlaty'],
        order_no: i['order_no'], date: i['date'], products: i['product'], orderStatus: i['orderStatus'],
        shipping: i['shipping'], subtotal: i['subtotal'], total: i['total'],shipping_type:i['shipping_type'],cancle_reason: i['cancle_reason']);
      _orderHistoryList.add(p);
    }
    return _orderHistoryList;
  }

  @override
  void initState() {
    super.initState();
    _allOrderHistory = _getOrderHistory();
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  void _onRefresh() async{

    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      _allOrderHistory = _getOrderHistory();

    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    print("loadings");
    await Future.delayed(Duration(milliseconds: 1000));
    if(mounted)
      setState(() {
        print("loadingssssss");

      });
    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.5,
        centerTitle: true,
        title: (Text('Order History', style: TextStyle(),)),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: WaterDropHeader(),
        child: FutureBuilder(
          future: _allOrderHistory,
          builder: (c, s) {
            if (s.connectionState != ConnectionState.done) {
              return Container(height: 400,
                child: Center(
                  child: CircularProgressIndicator(valueColor:
                  AlwaysStoppedAnimation<Color>(AppTheme.redColor),)
                ),
              );
            } else {
              if (s.hasError || s.data.isEmpty) {
                return Container(height: 400,
                  child: Center(child: Text('No Orders Found.',
                    style: TextStyle(color: Colors.black87, fontSize: 18),),),
                );
              } else {
                return Container(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: s.data.length,
                    itemBuilder: (c, i) {
                      return _orderHistoryListItem(s, i);
                    },
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _orderHistoryListItem(AsyncSnapshot s, int i) {
    var totalamt =0;
    if(s.data[i].shipping == null)
      {
         totalamt = s.data[i].total+ int.parse(s.data[i].penlaty);

      }else{
       totalamt = s.data[i].total + int.parse(s.data[i].shipping)+ int.parse(s.data[i].penlaty);

    }

    print("totalamt $totalamt");

    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,),
              Text('Order No : ${s.data[i].order_no}'),
              SizedBox(height: 10,),
              Text('Date : ${s.data[i].date}'),
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(padding: EdgeInsets.all(3.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Order Amount', style: TextStyle(fontSize: 13.0,
                              color: Colors.black54),),
                          Container(
                            margin: EdgeInsets.only(top: 3.0),
                            child: Text('₹ ${totalamt}',
                              style: TextStyle(fontSize: 15.0,
                                  color: Colors.black87),),
                          ),
                        ],
                      )
                  ),
                  Container(padding: EdgeInsets.all(3.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(' Products', style: TextStyle(fontSize: 13.0,
                              color: Colors.black54),),
                          Container(
                            margin: EdgeInsets.only(top: 3.0),
                            child: Text('${s.data[i].products.length}', style: TextStyle(
                                fontSize: 15.0, color: Colors.black87),
                            ),),
                        ],
                      )
                  ),
                ],
              ),
              Divider(height: 10.0, color: Colors.grey.shade500,),
              SizedBox(height: 3,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Order Status', style: TextStyle(color: Colors.grey, fontSize: 16.5),),
                  SizedBox(width: 25,),
                  _orderStatus('${s.data[i].orderStatus}'),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) =>
            HistoryProductDetailsPage(orderHistory: s.data[i],cancel_charge: cancel_charge)));
      },
    );
  }

  Widget _orderStatus(String status) {
    String sts = 'Order Placed';
    Color _bgColor = Colors.green;
    switch (status) {
      case '1':
        sts = 'Order Placed';
        _bgColor = Colors.green;
        break;
      case '2':
        sts = 'Accepted';
        _bgColor = Colors.green;
        break;
      case '3':
        sts = 'Dispatched';
        _bgColor = Colors.green;
        break;
      case '4':
        sts = 'Delivered';
        _bgColor = Colors.blue;
        break;
      case '5':
        sts = 'Cancelled';
        _bgColor = Colors.red;
        break;
      default:
        sts = 'Order Placed';
        _bgColor = Colors.green;
        break;
    }
    return ClipRRect(borderRadius: BorderRadius.circular(6),
      child: Container(width: 110, height: 36,
        color: _bgColor,
        child: Center(
          child: Text('$sts', style: TextStyle(color: Colors.white, fontSize: 15),),
        ),
      ),
    );
  }


}
