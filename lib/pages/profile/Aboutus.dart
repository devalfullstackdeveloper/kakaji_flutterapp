
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Aboutus extends StatefulWidget {
  @override
  _AboutusState createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {

  static const htmlData = """
<h4>
    About Us
</h4>
<h5>
    Buy Stationery online through Kakaji Store
</h5>
<p>
    Kakaji store is for books and stationary supplies which is established in
    2013. You can buy stationary online and we do door to door delivery. Just
    take your phone and place your order. We try our best to deliver it as soon
    as possible.
</p>
<p>
    You can manage your regular necessities and stock up for your home and
    office. We are offering supplies at wholesales price for retail products.
    Now we are delivering in Mehsana, Gujarat and planning to expand it. We
    assure you to provide best product and we won't disappoint you. We always
    look forward to our customers's feedback.
</p>
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About us'),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Html(
            data: htmlData,
          ),
        ),
      ),
    );
  }
}
