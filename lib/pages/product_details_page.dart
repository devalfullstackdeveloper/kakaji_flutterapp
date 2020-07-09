import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kakaji/pages/search/Searchbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakaji/models/product.dart';
import 'package:kakaji/pages/cart/cart_page.dart';
import 'package:kakaji/utils/apptheme.dart';
import 'package:kakaji/utils/connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kakaji/utils/custom_stepper.dart';
import 'login/login_page.dart';


class ProductDetailsPage extends StatefulWidget {
  final Product product;
  ProductDetailsPage({this.product});
  

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String _mrp, _buy, _pack;
  String _product;
  List _allProduct = [];
  int c = 1;
  int userId = 0;
  String _radioValue ="0";
  int _currentIndex = 1;
  bool _shwooffer = false;
  String defaultseelected ="";

  _getUserDetails() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = _prefs.getInt("user_id") ?? 0;
      print('user id is $userId');
    });
  }

  _addProductToCart() async {
    if (userId == 0) {
      _showLoginDialog('Login Required', 'You must login to add items to cart.');
      return;
    }
    print('pid ${widget.product.id}, price ${widget.product.saleps}, quantity $c');
    var response = await http.post(Connection.cartAdd, body: {
      'user_id' : '$userId',
      'product': "${widget.product.id}",
      'quantity': "$c",
      'price': "${widget.product.saleps}",
      "offer":"${defaultseelected}",
      //'package': '$_pack',
    });
    var decodedData = json.decode(response.body);
    print("cart added $decodedData");
    print('add cart status -> ${decodedData}');
    if (decodedData['status'] == true) {
      _showAlert('Product added to cart', 'This product has been successfully added to cart.');
    }
    else {
      _showAlert('Alert', '${decodedData['message']}');
    }
  }
  var i,highlits;

  @override
  void initState() {
    super.initState();
    _getUserDetails();

    if(widget.product.detail!= null){
    highlits =  widget.product.detail.replaceAll("<br>", "");

    }
    if(widget.product.buy1 != null){
      setState(() {
        _shwooffer = true;
        validate.add(widget.product.buy1.toString());
        offername.add(widget.product.get1.toString());

        if(widget.product.buy2!= null){
          validate.add(widget.product.buy2.toString());
          offername.add(widget.product.get2.toString());
        }

        if(widget.product.buy3 != null){
          validate.add(widget.product.buy3.toString());
          offername.add(widget.product.get3.toString());
        }
      });
    }


  }



  List<String> validate =[];
  List<String> offername =[];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(elevation: 0.5,
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c) => Searchbar()));
              print("tapssss");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search,color: Colors.black,),
            ),
          ),
        ],
       // title: Text('${widget.product.name}'),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        //shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${widget.product.name}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),maxLines: 3,),
          ),
          SizedBox(height: 10,),
          _carousalSlider(),
        //  _imageslide(),
         /* FadeInImage(placeholder: AssetImage('images/placeholder.png'),
            image: NetworkImage('${Connection.imagePath}/${i[0]}'),
            width: double.infinity, height: 300, fit: BoxFit.contain,),*/
//          Image.network('${Connection.imagePath}/${i[0]}',
//             height: 260, fit: BoxFit.contain,),
          SizedBox(height: 8,),
          Padding(padding: const EdgeInsets.only(left: 20),
            child: RichText(
              text: TextSpan(text: 'Buy: ₹ ${widget.product.saleps}', style: TextStyle(color: Colors.black87,
                  fontSize: 23),
              children: [
                TextSpan(text: '   '),
                (widget.product.mrps.toString() == widget.product.saleps.toString())?  TextSpan(text: '   '): TextSpan(text: 'MRP: ₹ ${widget.product.mrps}', style: TextStyle(color: Colors.grey,
                    decoration: TextDecoration.lineThrough, fontSize: 18)),
              ]
              ),),
          ),
          SizedBox(height: 10,),
          Divider(color: Colors.grey,),
          SizedBox(height: 8,),


//          Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
//            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Text('Pack Size :', style: TextStyle(fontSize: 18, color: Colors.black87),),
//                SizedBox(width: 70,),
//                Flexible(
//                  child: Container(height: 35,
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(6),
//                      border: Border.all(width: 1.3, color: Colors.grey)
//                    ),
//                    child: DropdownButtonHideUnderline(
//                      child: ButtonTheme(
//                        alignedDropdown: true,
//                        child: DropdownButton<String>(
//                          itemHeight: 55, isExpanded: true,
//                          hint: Text('Quantity',),
//                          value: _product,
//                          items: _allProduct.map((value) {
//                            return DropdownMenuItem<String>(
//                              value: value['packtitle'],
//                              child: Text(value['packtitle'], maxLines: 5,),
//                            );
//                          }).toList(),
//                          onChanged: (v) {
//                            setState(() {
//                              _product = v;
//                              _allProduct.forEach((i) {
//                                if (i['packtitle'] == _product) {
//                                  _mrp = i['mrp'];
//                                  _buy = i['salep'];
//                                  _pack = i['pack'];
//                                }
//                              });
//                            });
//                          },
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//          SizedBox(height: 12,),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Quantity :', style: TextStyle(fontSize: 18, color: Colors.black87),),
                CartStepper(
                  initialValue: c,
                  maxValue: 1000,
                  onChanged: (int value) {
                    setState(() {
                      c = value;
                      _currentIndex = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),

          (_shwooffer)? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(color: Colors.grey,),

              Container(height: 45, width:double.infinity, color: AppTheme.yellowofferColor,
                child: Center(
                  child: Text('Offer Season',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
              Container(
                height: 160,
                child: ListView.builder(
                    itemCount: validate.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (c, i) {

                      return Row(
                        children: <Widget>[

                          (validate[i] == _currentIndex.toString() || int.parse(validate[i])  < _currentIndex  )?  Radio(
                            value: validate[i],
                            groupValue: _radioValue,
                            onChanged: (val) {
                              print("val $val int $i");

                              setState(() {
                                _radioValue = val.toString();
                                if(i ==0){
                                  defaultseelected = "buy1";
                                  return;
                                }else  if(i ==1){
                                  defaultseelected = "buy2";
                                  return;
                                }else if(i ==2){
                                  defaultseelected = "buy3";
                                  return;
                                }

                              });
                            }) : Radio(
                              value: validate[i],
                              groupValue: _radioValue,
                              onChanged:null,
                          ),
                          Expanded(child: Text("buy ${validate[i]} and get ${offername[i]}")),
                        ],
                      );
                    }),
              ),
              Divider(color: Colors.grey,),

            ],
          ):SizedBox(),
          //SizedBox(height: 12,),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                (widget.product.option2 == "1")? Column(
               children: <Widget>[
                 Image.network("${Connection.offericonPath}/cod.png",width: 77,height: 70,),

               ],
             ):SizedBox(),
             SizedBox(width: 10,),
                (widget.product.option1 == "1")?  Column(
               children: <Widget>[
                 Image.network("${Connection.offericonPath}/noreturn.png",width: 50,height: 50,),

               ],
             ):SizedBox(),
             SizedBox(width: 10,),
                (widget.product.option3 == "1")?  Column(
               children: <Widget>[
                 Image.network("${Connection.offericonPath}/warrenty.png",width: 100,height: 100,),

               ],
             ):SizedBox(),
             SizedBox(width: 10,),
                (widget.product.option4 == "1")? Column(
                  children: <Widget>[
                    Image.network("${Connection.offericonPath}/delivery.png",width: 75,height: 75,),
                  ],
                ):SizedBox(),
              ],
            ),
          ),
          
          SizedBox(height: 12,),
          Divider(height: 1.3, color: Colors.grey,),
          SizedBox(height: 12,),
          (widget.product.detail == null)?SizedBox():  Container(height: 52, width:double.infinity, color: AppTheme.separatorColor,
            child: Center(
              child: Text('Highlights',style: TextStyle(fontSize: 20),),
            ),
          ),
          (widget.product.detail == null)?SizedBox():
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('${highlits}', style: TextStyle(color: Colors.black87,
                fontSize: 16.8), textAlign: TextAlign.justify,),
          ),
          SizedBox(height: 12,),
          Container(height: 52, width:double.infinity, color: AppTheme.separatorColor,
            child: Center(
              child: Text('About this Product',style: TextStyle(fontSize: 20),),
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('${widget.product.description}', style: TextStyle(color: Colors.black87,
                fontSize: 16.8), textAlign: TextAlign.justify,),
          ),
          SizedBox(height: 12,),
          (widget.product.description1 == null)?SizedBox():
          Container(height: 52, width:double.infinity, color: AppTheme.separatorColor,
            child: Center(
              child: Text('Product Details',style: TextStyle(fontSize: 20),),
            ),
          ),
          SizedBox(height: 5,),
          (widget.product.description1 == null)?SizedBox():
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('${widget.product.description1}', style: TextStyle(color: Colors.black87,
                fontSize: 16.8), textAlign: TextAlign.justify,),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(height: 50,
          child: Row(
            children: <Widget>[
              Flexible(flex: 5,
                child: GestureDetector(
                  child: Container(height: 50,
                    color: Colors.blue,
                    child: Center(
                      child: Text('View Cart', style: TextStyle(color: Colors.white,
                          fontSize: 18),),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => CartPage()));
                  },
                ),
              ),
              Flexible(flex: 5,
                child: GestureDetector(
                  child: Container(height: 50,
                    color: AppTheme.redColor,
                    child: Center(
                      child: Text('Add to Cart', style: TextStyle(color: Colors.white,
                          fontSize: 18),),
                    ),
                  ),
                  onTap: _addProductToCart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carousalSlider() {
   var img = json.decode(widget.product.imageName);
   // print("image $i");
    return CarouselSlider.builder(
        height: 250, viewportFraction: 1.9, aspectRatio: 2.6,
        autoPlay: true, enlargeCenterPage: true,
        itemCount: img.length,
        itemBuilder: (c, i) {
          print("image ${img[i]}");
          return Image.network('${Connection.imagePath}/${img[i]}',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.contain,);
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
