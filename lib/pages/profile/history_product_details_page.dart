import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kakaji/main.dart';
import 'package:kakaji/models/order_history.dart';
import 'package:kakaji/utils/connection.dart';
import 'package:kakaji/utils/status_stepper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http ;

class HistoryProductDetailsPage extends StatelessWidget {
  final OrderHistory orderHistory;
   var cancel_charge ;
  HistoryProductDetailsPage({this.orderHistory,this.cancel_charge});

 _orderCancel(ctx,reason) async {
   print("lnclakc ${orderHistory.orderStatus} rason $reason ,orderid ${orderHistory.order_id}");
   var charges ;
   if(orderHistory.orderStatus != "1"){
     charges =cancel_charge;
   }else{
     charges = "0";
   }

   print("object $charges");


    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(Connection.orderCancel, body: {
      'order_id' : orderHistory.order_id.toString(),
      'order_status' : orderHistory.orderStatus.toString(),
      'reason' : reason.toString(),
      'cancel_charge' : '${charges.toString()}',
    });
    var decodedData = json.decode(response.body);
    print("decodedata $decodedData");
    var status = decodedData['status'];
   if(status == true){
     Navigator.push(ctx, MaterialPageRoute(builder: (c) =>MyApp()));
   }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 1.0,
        centerTitle: true,
        title: Text('Order Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Text('Order No : ${orderHistory.order_no.toString()}'),
          SizedBox(height: 6,),
          Text('Date : ${orderHistory.date}'),
          SizedBox(height: 12,),
          Card(
            child: Container(width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Billing/Shipping Address', style: TextStyle(fontWeight: FontWeight.w600),),
                  SizedBox(height: 12,),
                  Text('${orderHistory.address['name']}', style: TextStyle(fontSize: 18),),
                  SizedBox(height: 8,),
                  Text('${orderHistory.address['house_no']}  ${orderHistory.address['area']}'
                      ' ${orderHistory.address['city']} ${orderHistory.address['landmark']} '
                      ' ${orderHistory.address['pincode']}.'
                      ' - (M) ${orderHistory.address['mobile']}',
                    maxLines: null,),
                ],
              ),
            ),
          ),
          StatusStepper(orderStatus: int.parse('${orderHistory.orderStatus}'),shipping_type:orderHistory.shipping_type),
          (orderHistory.orderStatus == "5")? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Canceled Reason', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text('${orderHistory.cancle_reason}', style: TextStyle(fontSize: 14,),maxLines: 5,),
              ],
            ),
          ) : SizedBox(),
          _productsList(),
          Card(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Amount Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Sub Total :', style: TextStyle(fontSize: 16),),
                            Text('₹ ${orderHistory.subtotal}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                          ],
                        ),
                        SizedBox(height: 6,),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Shipping :', style: TextStyle(fontSize: 16),),
                            (orderHistory.shipping == null)?
                            SizedBox() :
                            Text('₹ ${orderHistory.shipping}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                          ],
                        ),
                        SizedBox(height: 6,),
                        (orderHistory.penlaty =='0')?SizedBox():  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Penelty :', style: TextStyle(fontSize: 16),),
                            (orderHistory.shipping == null)?
                            SizedBox() :
                            Text('₹ ${orderHistory.penlaty}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                          ],
                        ),
                        SizedBox(height: 6,),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Total :', style: TextStyle(fontSize: 16),),
                            (orderHistory.shipping == null )?
                            Text('₹ ${orderHistory.subtotal}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
                                : Text('₹ ${orderHistory.subtotal + int.parse(orderHistory.shipping)+ int.parse(orderHistory.penlaty)}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                          ],
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          (orderHistory.orderStatus =="5" || orderHistory.orderStatus =="4" )?SizedBox(): Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            width: double.infinity,
            child: RaisedButton(
              padding: EdgeInsets.all(12.0),
             //s shape: StadiumBorder(),
              child: Text("CANCEL ORDER", style: TextStyle(color: Colors.white),),
              color: Colors.orange,
              onPressed: (){
                _showAlerts(context);
              },
            ),
          ),
        ],
      ),
    );
  }
  TextEditingController _reasonController = TextEditingController();
  _showAlerts(ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are you Sure ?"),
          content: TextFormField(
            controller: _reasonController,
            maxLines: 3,
            decoration: const InputDecoration(
              //icon: Icon(Icons.person),
              hintText: 'Enter Reasion for cancelling the order',
              labelText: 'Enter Reasion for cancelling the order',
            ),
            onSaved: (String value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String value) {
              return value.contains(' ') ? 'Enter the reason' : null;
            },
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
            print("_reasonController.text ${_reasonController.text}");
            if(_reasonController.text.isNotEmpty){
              print("empty");
              print("lnclakc ${orderHistory.orderStatus} ,orderid ${orderHistory.order_id}");

              _orderCancel(ctx,_reasonController.text);
              Navigator.of(context).pop();
            }
              //  _orderCancel(ctx,_reasonController.text);
                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _productsList() {
    return Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(left: 12, top: 10),
            child: Text('Ordered Products',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.5),),
          ),
          SizedBox(height: 6,),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: orderHistory.products.length,
            itemBuilder: (c, i) {
              return _productListItem(i);
            },
            separatorBuilder: (c, i) {
              return Divider(color: Colors.grey,);
            },
          ),
        ],
      ),
    );
  }

  Widget _productListItem(int i) {
    var image = json.decode('${orderHistory.products[i]['image']}');
    return Container(
      child: Row(
        children: <Widget>[
          FadeInImage.assetNetwork(height: 70, width: 70,
              placeholder: 'assets/kakajilgo.png',
              image: '${Connection.imagePath}${image[0]}'),
          SizedBox(width: 12,),
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(

                  child: Text('${orderHistory.products[i]['product']}', style: TextStyle(fontSize: 16),)),
              SizedBox(height: 4,),
            //  Text('Weight : ${orderHistory.products[i]['package']}'),
             // SizedBox(height: 4,),
              Text('Quantity : ${orderHistory.products[i]['quantity']} x '
                  '₹ ${orderHistory.products[i]['price']}'),
            ],
          ),
        ],
      ),
    );
  }


}

