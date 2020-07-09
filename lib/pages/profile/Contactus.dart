
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Contactus extends StatefulWidget {
  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {

  static const htmlData = """
<div>
    <br/>
</div>
<div>
    <ul>
        <li>
            <div>
                <h6>
                    ADDRESS
                </h6>
            </div>
            <div>
                <p>
                    Shop No.1, Maniba App.,Opp. Prashant Cinema,
                    <br/>
                    Gayatri mandir road,Mehsana-384002,
                    <br/>
                    Gujarat,India
                </p>
            </div>
        </li>
        <li>
            <div>
                <h6>
                    PHONE
                </h6>
            </div>
            <div>
                <p>
                    +91-9265402371
                </p>
                <p>
                    +91-7778977213
                </p>
            </div>
        </li>
        <li>
            <div>
                <h6>
                    EMAIL
                </h6>
            </div>
            <div>
                <p>
                    kakajiongoing@gmail.com
                </p>
            </div>
        </li>
    </ul>
</div>
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
