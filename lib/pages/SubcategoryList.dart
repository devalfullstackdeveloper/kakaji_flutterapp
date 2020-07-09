import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakaji/models/subcategory.dart';
import 'package:kakaji/pages/search/Searchbar.dart';
import 'package:kakaji/utils/apptheme.dart';
import 'package:kakaji/utils/connection.dart';
import 'product_list_page.dart';

class SubcategoryList extends StatefulWidget {
  SubcategoryList(this.id,this.title);
  var id,title;

  @override
  _SubcategoryListState createState() => _SubcategoryListState();
}
final List<String> imgList = [
  'assets/banner1.jpg','assets/banner2.jpg','assets/banner3.jpg','assets/banner4.jpg','assets/banner1.jpg'
];
Future<List<SubCategory>> _subcat;

class _SubcategoryListState extends State<SubcategoryList> {
  final List<SubCategory> subctgry = [];

  Future<List<SubCategory>> subcategory() async {
    print("category id  ${widget.id.toString()}");
    var response = await http.post(Connection.subcategory,body: {
      "main_id":widget.id.toString()
    });
    var decodedData = json.decode(response.body);
    var data = decodedData['data'];
    print("data is $data");
//  print("decodedata $data");
    for(var k in data){
      SubCategory bm =SubCategory(id: k['id'],title:k['title'],sort_order: k['sort_order'],mobileImage:k['mobileImage']);
      subctgry.add(bm);
    }
return subctgry;
    print("banner Length ${subctgry.length}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subcat =  subcategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.title}"),
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
      ),
      body: _subcategoryFuture(),
    );
  }
  Widget _subcategoryFuture() {
    return FutureBuilder(
      future: _subcat,
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return Container(height: 36, color: Colors.white,);
        }else if (s.data.isEmpty) {
          return Center(child: Text('No Products Found.',
            style: TextStyle(color: Colors.black87, fontSize: 18),),);
        } else {
          if (s.hasError) {
            return Container(height: 36, color: Colors.white,);
          } else {
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: s.data.length,
                //itemCount:s.data.length,
                itemBuilder: (c, i) {
                  return  _subcategoryList(s,c,i);
                });
          }
        }
      },
    );
  }

  Widget _subcategoryList(s,c,i){
  //  print("dtaa iage ${s.data[i].image}");
    return GestureDetector(
      child: Card(
/*
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
*/
        color: AppTheme.yellowColor,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    width: 50,height: 50,
                    padding: EdgeInsets.all(4),
                    child:   FadeInImage.assetNetwork(
                      placeholder: "assets/loader.gif",
                      image: '${s.data[i].mobileImage}',  width: 50,
                    ),
                  //  new Image.network("${s.data[i].mobileImage}",fit: BoxFit.cover,width: 50,)
                ),
                SizedBox(width: 20,),
                Text("${s.data[i].title}",style: TextStyle(fontSize: 16,),),
              ],
            ),
/*
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey,
                height: 1,
              ),
            ),
*/
          ],
        ),
      ),
      onTap: (){
        //ProductList
        Navigator.push(context, MaterialPageRoute(builder: (c) =>ProductListPage(categoryId: s.data[i].id, // s.data[i].id,
          categoryName: s.data[i].title,)));
      },
    );
  }
}
