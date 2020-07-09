import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ContactUsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.5,
        centerTitle: true,
        title: Text('Contact Us'),
      ),
      bottomNavigationBar: SafeArea(
        child: GestureDetector(
          child: Container(
            height: 50,
            color: Colors.green,
            child: Center(
              child: Text('CALL NOW', style: TextStyle(color: Colors.white),),
            ),
          ),
          onTap: () {
            UrlLauncher.launch("tel://+91721187222");
          },
        ),
      ),
      body: Container(padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.location_on),
                SizedBox(width: 10,),
                Expanded(
                  child: Text('1, Maniba App ,Opp. Prashant Cinema,Gayatri mandir road,Mehsana',
                    maxLines: 10,),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: <Widget>[
                Icon(Icons.link),
                SizedBox(width: 10,),
                Expanded(
                  child: GestureDetector(
                    child: Text('kakajistore.in', style: TextStyle(color: Colors.green,
                        decoration: TextDecoration.underline),),
                    onTap: () {
                      UrlLauncher.launch("http://kakajistore.in");
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: <Widget>[
                Icon(Icons.access_time),
                SizedBox(width: 10,),
                Expanded(
                  child: Text('24 Hours',),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: <Widget>[
                Icon(Icons.phone_iphone),
                SizedBox(width: 10,),
                Expanded(
                  child: Text('+91 7211187222',),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: <Widget>[
                Icon(Icons.email),
                SizedBox(width: 10,),
                Expanded(
                  child: GestureDetector(
                    child: Text('info@kakajistore.in', style: TextStyle(color: Colors.green,
                        decoration: TextDecoration.underline),),
                    onTap: () {
                      UrlLauncher.launch("mailto://info@kakajistore.in");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
