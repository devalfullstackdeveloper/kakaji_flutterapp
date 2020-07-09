import 'package:flutter/material.dart';
import 'package:kakaji/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:kakaji/pages/search/search_list_page.dart';
import 'dart:convert';
import 'package:kakaji/utils/connection.dart';


class Searchbar extends StatefulWidget {

  @override
  _SearchbarState createState() => _SearchbarState();
}
//List dummySearchList;

//var items = List<String>();

class _SearchbarState extends State<Searchbar> {

  TextEditingController editingController = TextEditingController();
  // final duplicateItems = List<String>();
  //var items = List<String>();
  final List<String> dummySearchList = [];

  final List<dynamic> items = [];
  final List<dynamic> sel = [];
  final List<dynamic> duplicateItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // duplicateItems.add(widget.itemmaster[]);
    // items.addAll(duplicateItems);

  }
  List<Product> _bestOffersList = [];

  Future<List<Product>> _searchkeyword(keywords) async {
    var response = await http.post(Connection.search,body: {
      'keyword':'$keywords'
    });

    var decodedData = json.decode(response.body);
    _bestOffersList.clear();
    print("data decode $decodedData");
 //   var webresp = decodedData['data'];
   // print("daya $webresp");
    for (var i in decodedData) {
      Product a = Product(id: i["id"], name:i["name"], description: i["description"],
          qty_price: i["qty_price"], imageName: i["image"],mrps: i['mrp'],saleps:i['salep']
          ,buy1: i['buy1'],buy2: i['buy2'],buy3: i['buy3'],get1: i['get1'],get2: i['get2'],get3: i['get3'],
          option1:i['option1'],option2:i['option2'],option3:i['option3'],option4:i['option4'],description1:i['description1'],detail:i['detail']
      );
      _bestOffersList.add(a);
    }
    setState(() {
      print('sub categs ${_bestOffersList.length}');
    });

    return _bestOffersList;
  }



  @override
  Widget build(BuildContext context) {
    //   print("item List : ${widget.itemmaster[0].Item_Description}");
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.orange,
                  accentColor: Colors.yellow,
                ),
                child: TextField(
                  onChanged: (value) {

                  //  _searchkeyword(value);
                  //  filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                child: Text("Search", style: TextStyle(color: Colors.white),),
                color: Colors.orange,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c) =>
                      search_list_page(editingController.text.toString())));
                },
              ),
            ),
//            Expanded(
//              child: ListView.builder(
//                shrinkWrap: true,
//                itemCount:_bestOffersList.length,
//                itemBuilder: (context, index) {
//
//                  // print("itemsssssss ${items[0]}");
//
//                  return GestureDetector(
//                    child: ListTile(
//                      title: Text('${_bestOffersList[index].name}'),
//                    ),
//                    onTap: (){
//                      print("jjjj ${sel.contains(_bestOffersList[index].name)}");
//
//
//                    },
//                  );
//                },
//              ),
//            ),
          ],
        ),
      ),
    );
  }


}

