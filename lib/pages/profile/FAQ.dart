
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {

  static const htmlData = """
<p>
    <strong>1.What is KAKAJISTORE?</strong>
</p>
<p>
    KAKAJISTORE is the most convenient hyper local delivery Store which gives
    the Stationery Product, School Books and Related Product, directly via your
    Mobile App &amp; web browser.
</p>
<p>
    <strong>2.What locations so you operate in?</strong>
</p>
<p>
    KAKAJISTORE currently operates in Mehsana (North Gujarat).
</p>
<p>
    <strong>3.How can you Place an Order with KAKAJISTORE?</strong>
</p>
<p>
    You can place an order with KAKAJISTORE, in any one of the following modes:
</p>
<p>
i. Online - just login to    <a href="http://www.kakajistore.in/" target="_blank">WWW.KAKAJISTORE.IN</a>
    and place your order and have the option of Delivery, Pickup &amp; Cash on
    delivery.
</p>
<p>
    ii. Use our mobile application - Download now on Playstore.
</p>
<p>
    <strong>4.What is Minimum Order Value?</strong>
</p>
<p>
    <strong> </strong>
    There is no minimum order value. However, we have a minimum order value to
    qualify for free delivery. A delivery charge will be levied against the
    order which do not reach the limit.
</p>
<p>
    <strong>5.What Can I do if there is any Problem with My Order?</strong>
</p>
<p>
    Our Representatives at KAKAJISTORE will assist you to solve your problems.
    Please call us on +91-9265402371 or email us on
    <a href="mailto:kakajiongoing@gmail.com" target="_blank">
        kakajiongoing@gmail.com
    </a>
    .
</p>
<p>
    <strong>
        6.How can I Make Changes to the Order I have made before and after
        Confirmation?
    </strong>
</p>
<p>
    Before checkout you can edit your products in the cart. You can cancel and
    reorder with the required list from the app and web. If you’ve already
    placed your order then you can only cancel your order.
</p>
<p>
    <strong>7.How long it will take to deliver my Order?</strong>
</p>
<p>
    After Accepting the order our average delivery time is between2-3 Hour.
    Delivery time depends on a lot of factors such as Marketplace order volume,
    our current order volume, traffic, weather, overall distance, order size
    etc. If You Are Placing the Order after 7PM, then we are Deliver your order
    Next Day. If there is any delay we always try to do our best and always try
    to convey it to you.
</p>
<p>
    <strong>8.Can I edit my order?</strong>
</p>
<p>
    Your order can be edited before it reaches the Marketplace. Once the order
    is placed you may not be able to edit its contents.
</p>
<p>
    <strong>
        9.Can I change the Delivery Address after placing the order?
    </strong>
</p>
<p>
    After you have placed an order with us any change in delivery address is
    not possible after you have placed an order with us. However, please get in
    touch with our team if there are slight modifications like changing the
    flat number, street name, landmark etc.
</p>
<p>
    <strong>10.Can you update me on My Order?</strong>
</p>
<p>
    Sure! In order to stay updated on the Order History.
</p>
<p>
    <strong> </strong>
</p>
<p>
    <strong> 11.How can I review my Receipt?</strong>
</p>
<p>
    <strong> </strong>
    We handover the Receipt from the delivery guy to you at the time of
    Delivery. Also, in the “Orders history” tab you can open your Order.
</p>
<p>
    <strong>12.What if I have my order related complaint?</strong>
</p>
<p>
    On the web/app you can use the “Contact Us” section. Our executives are
    always happy to help.
</p>
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),

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
