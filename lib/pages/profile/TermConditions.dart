
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TermCondition extends StatefulWidget {
  @override
  _TermConditionState createState() => _TermConditionState();
}

class _TermConditionState extends State<TermCondition> {

  static const htmlData = """
<p>
    <strong><u>1.Definitions</u></strong>
</p>
<p>
    In this document the following words shall have the following meanings:
</p>
<p>
    <em>1.1 </em>
    “Buyer” means the organization or person who buys Goods from the Seller
</p>
<p>
    <em>1.2 </em>
    “Conditions” means the terms and conditions of sale set out in this
    document and any special terms and conditions agreed in writing by the
    Seller.
</p>
<p>
    <em>1.3 </em>
    “Delivery date” means the date specified by the Seller when the Goods are
    to be delivered.
</p>
<p>
    <em>1.4 </em>
    “Goods” means the articles to be supplied to the Buyer by the Seller.
</p>
<p>
    <em>1.5 </em>
    “Intellectual Property Rights” means all patents, registered and
    unregistered designs, copyright, trademarks, know-how and all other forms
    of intellectual property wherever in the world enforceable.
</p>
<p>
    <em>1.6 </em>
    “Price” means the price set out in the list of prices of the Goods
    maintained by the Seller as amended from time to time or such other price
    as the parties may agree in writing plus such carriage, packing, insurance
    or other charges or interest on such as may be quoted by the Seller or as
    may apply in accordance with these conditions.
</p>
<p>
    <em>1.7 </em>
    “Seller” means kakaji Stationers.
</p>
<p>
    <strong><u>2.General</u></strong>
</p>
<p>
    <em>2.1 </em>
    These conditions shall apply to all contracts for the sale of Goods by the
    Seller to the Buyer to the exclusion of all other terms and conditions
    including any terms or conditions which the Buyer may seek to apply under
    any purchase order, order confirmation or similar document.
</p>
<p>
    <em>2.2 </em>
    All orders for Goods shall be deemed to be an offer by the Buyer to
    purchase Goods pursuant to these Conditions.
</p>
<p>
    <em>2.3 </em>
    Acceptance of delivery of the Goods shall be deemed conclusive evidence of
    the Buyer’s acceptance of these Conditions.
</p>
<p>
    <em>2.4 </em>
    Any variation to these Conditions (including any special terms and
    conditions agreed between the parties including without limitation as to
    discounts) shall be inapplicable unless agreed in writing by the Seller.
</p>
<p>
    <em>2.5 </em>
    Any advice, recommendation or representation given by the Seller or its
    employees or agents to the Buyer or its employees or agents as to the
    storage, application or use of the Goods or otherwise which is not
    confirmed in writing by the Seller is followed or acted upon entirely at
    the Buyer’s own risk, and, accordingly, the Seller shall not be liable for
    any such advice, recommendation or representation which is not so
    confirmed.
</p>
<p>
    <em>2.6 </em>
    Nothing in these Conditions shall affect the statutory rights of any Buyer
    dealing as a consumer.
</p>
<p>
    <strong><u>3.Price and Payment</u></strong>
</p>
<p>
    <em>3.1 </em>
    Payment of the Price is strictly cash (bank payment also) with order or
    cash on delivery.
</p>
<p>
    <em>3.2 </em>
    The Seller reserves the right to grant, refuse restrict, cancel or alter
    credit terms at its sole discretion at any time.
</p>
<p>
    <em>3.3 </em>
    If payment of the Price or any part thereof is not made by the due date,
    the Seller shall be entitled to.
</p>
<p>
    <em>3.4 </em>
    Require payment in advance of delivery in relation to any Goods not
    previously delivered.
</p>
<p>
    <em>3.5 </em>
    Refuse to make delivery of any undelivered Goods whether ordered under the
    contract or not and without incurring any liability whatever to the Buyer
    for non-delivery or any delay in delivery.
</p>
<p>
    <em>3.6 </em>
    Appropriate any payment made by the Buyer to such of the Goods (or Goods
    supplied under any other contract) as the Seller may think fit.
</p>
<p>
    <em>3.7 </em>
    Terminate the contract.
</p>
<p>
    <strong><u>4.Description</u></strong>
</p>
<p>
    Any description given or applied to the Goods is given by way of
    identification only and the use of such description shall not constitute a
    sale by description. For the avoidance of doubt, the Buyer hereby affirms
    that it does not in any way rely on any description when entering into the
    contract.
</p>
<p>
    <strong></strong>
</p>
<p>
    <strong><u>5.Offer</u></strong>
    <strong></strong>
</p>
<p>
    <em>5.1 </em>
    For Activation Offer given by Seller. It’s Activation only when Customer
    Select Offer from The Product Details Page. Otherwise No Offer Will Grant
    to Customer.
</p>
<p>
    <em>5.2 </em>
    Product Item given as Offer to Customer it’s Not Replace or Not Exchange or
    Not Taken Back.
</p>
<p>
    <em>5.3 </em>
    Offer May be Close or Drop by Seller at any Point of Time. Seller Own
    discretion Power to Close or Drop Offer.
</p>
<p>
    <strong></strong>
</p>
<p>
    <strong></strong>
</p>
<p>
    <strong><u>6.Delivery</u></strong>
    <strong></strong>
</p>
<p>
    <em>6.1 </em>
    Unless otherwise agreed in writing, delivery of the Goods shall take place
    at the address specified by the Buyer on the date specified by the Seller.
    The Buyer shall make all arrangements necessary to take delivery of the
    Goods whenever they are tendered for delivery.
</p>
<p>
    <em>6.2 </em>
    The date of delivery specified by the Seller is an estimate only. Time for
    delivery shall not be of the essence of the contract and while every
    reasonable effort will be made to comply with such dates compliance is not
    guaranteed and the Buyer shall have no right to damages or to cancel the
    order for failure for any cause to meet any delivery date stated.
</p>
<p>
    <em>6.3 </em>
    If the Seller is unable to deliver the Goods for reasons beyond its
    control, then the Seller shall be entitled to place the Goods in storage
    until such time as delivery may be affected and the Buyer shall be liable
    for any expense associated with such storage.
</p>
<p>
    <em>6.4 </em>
    If the Buyer fails to accept delivery of Goods on the delivery date the
    Seller reserves the right to invoice the Goods to the Buyer and charge him
    therefore. In addition the Buyer shall then pay reasonable storage charges
    or demurrage as appropriate in the circumstances until the Goods are either
    dispatched to the Buyer or disposed of elsewhere.
</p>
<p>
    <em>6.5 </em>
    Notwithstanding that the Seller may have delayed or failed to deliver the
    Goods (or any of them) promptly the Buyer shall be bound to accept delivery
    and to pay for the Goods in full provided that delivery shall be tendered
    at any time.
</p>
<p>
    <em>6.6 </em>
    Customer Find the Defect in Delivered Items, Then Customer Need to inform
    the Seller within 24 Hrs from the Bill Date
</p>
<p>
    <strong><u>7.Acceptance</u></strong>
    <strong></strong>
</p>
<p>
    <em>7.1 </em>
    The Seller is a distributor of goods and the Buyer is exclusively
    responsible for detailing the specification of the Goods, for ascertaining
    the use to which they will be put and for determining their ability to
    function for that purpose.
</p>
<p>
    <em>7.2 </em>
    The Buyer shall not remove or otherwise interfere with the marks or numbers
    on the Goods.
</p>
<p>
    <a name="_GoBack"></a>
    <em>7.3 </em>
    The Buyer shall accept delivery of the Goods tendered notwithstanding that
    the quantity so delivered shall be either greater or lesser than the
    quantity purchased provided that any such discrepancy shall not exceed 5%,
    the Price to be adjusted pro-rata to the discrepancy.
</p>
<p>
    <em>7.4 </em>
    Seller Have Right to Respect or Cancel the Placed Order.
</p>
<p>
    <em>7.5 </em>
    When Order Status as Out For Delivery and During that Customer Cancel
    Order, then liable for Penalty.
</p>
<p>
    <strong><u>8. Risk and Title</u></strong>
</p>
<p>
    <em>8.1 </em>
    Risk of damage or loss of the Goods shall pass to the Buyer in the case of
    Goods to be delivered at the Seller’s premises, at the time when the Seller
    notifies the Buyer that the Goods are available for collection, or in the
    case of Goods to be delivered otherwise than at the Seller’s premises, at
    the time of delivery.
</p>
<p>
    <em>8.2 </em>
    Notwithstanding delivery and the passing of risk in the Goods, or any other
    provision of these conditions, the property in the Goods shall not pass to
    the Buyer until the Seller has received in cash or cleared funds payment in
    full of the Price of the Goods and of all other Goods agreed to be sold by
    the Seller to the Buyer for which payment is then due.
</p>
<p>
    <em>8.3 </em>
    Until such time as the property in the Goods passes to the Buyer, the Buyer
    shall hold the Goods as the Seller’s fiduciary agent and bailer, and shall
    keep the Goods separate from those of the Buyer and third parties and
    properly stored, protected and insured and identified as the Seller’s
    property.
</p>
<p>
    <em>8.4 </em>
    Until payment of the Price the Buyer shall be entitled to resell or use the
    Goods in the course of its business but shall account to the Seller for the
    proceeds of sale or otherwise of the Goods, whether tangible or intangible
    including insurance proceeds, and shall keep all such proceeds separate
    from any monies or property of the Buyer and third parties and, in the case
    of tangible proceeds, properly stored, protected and insured.
</p>
<p>
    <em>8.5 </em>
    Until such time as the property in the Goods passes to the Buyer (and
    provided that the Goods are still in existence and have not been resold)
    the Seller shall be entitled at any time to require the Buyer to deliver up
    the Goods to the Seller and if the Buyer fails to do so forthwith to enter
    upon any premises of the Buyer or of any third party where the Goods are
    stored and repossess the Goods.
</p>
<p>
    <em>8.6 </em>
    The Seller shall be entitled to recover the Price notwithstanding that
    property in any of the Goods has not passed from the Seller.
</p>
<p>
    <strong><u>9. Warranty</u></strong>
</p>
<p>
    <strong></strong>
</p>
<p>
    <em>9.1 </em>
    Where the Goods are found to be defective, the Seller shall, replace
    defective Goods free of charge within the warranty period if acceptable
    from the date of delivery, subject to the following conditions;
</p>
<p>
    9.1.1. The Buyer notifying the Seller in writing immediately upon the
    defect becoming apparent.
</p>
<p>
    9.1.2. The defect being due to faulty design, materials or workmanship.
</p>
<p>
    <em>9.2 </em>
    Any Goods to be repaired or replaced shall be returned to the Seller at the
    Buyer’s expense, if so requested by the Seller.
</p>
<p>
    <em>9.3 </em>
    The Seller shall be entitled in its absolute discretion to refund the Price
    of the defective Goods in the event that the Price has already been paid.
</p>
<p>
    <strong><u>10</u></strong>
    <strong><u>.</u></strong>
    <strong><u> Liability</u></strong>
    <strong></strong>
</p>
<p>
    <em>10.1 </em>
    No liability of any nature shall be incurred or accepted by the Seller in
    respect of any representation made by the Seller, or on its behalf, to the
    Buyer, or to any party acting on its behalf, prior to the making of this
    contract where such representations were made or given in relation to:-
</p>
<p>
    10.1.1. The correspondence of the Goods with any description or sample;
</p>
<p>
    10.1.2. The quality of the Goods; or
</p>
<p>
    10.1.3. The fitness of the Goods for any purpose whatsoever.
</p>
<p>
    <em>10.2 </em>
    Except where the Buyer deals as a consumer all other warranties, conditions
    or terms relating to fitness for purpose, quality or condition of the
    Goods, whether express or implied by statute or common law or otherwise are
    hereby excluded from the contract to the fullest extent permitted by law.
</p>
<p>
    <em>10.3 </em>
    For the avoidance of doubt the Seller will not accept any claim for
    consequential or financial loss of any kind however caused.
</p>
<p>
    <strong><u>11. Force Majeure</u></strong>
    <strong></strong>
</p>
<p>
    The Seller shall not be liable for any delay or failure to perform any of
    its obligations if the delay or failure results from events or
    circumstances outside its reasonable control, including but not limited to
    acts of God, strikes, lock outs, accidents, war, fire, breakdown of plant
    or machinery or shortage or unavailability of raw materials from a natural
    source of supply, and the Seller shall be entitled to a reasonable
    extension of its obligations. If the delay persists for such time as the
    Seller considers unreasonable, it may without liability on its part,
    terminate the contract or any part of it.
</p>
<p>
    <strong><u>12</u></strong>
    <strong><u>. </u></strong>
    <strong><u>Waiver</u></strong>
    <strong></strong>
</p>
<p>
    The failure by either party to enforce at any time or for any period any
    one or more of the Conditions herein shall not be a waiver of them or of
    the right at any time subsequently to enforce all Conditions of this
    Agreement.
</p>
<p>
    <strong><u>13. No Set Off</u></strong>
    <strong></strong>
</p>
<p>
    The Buyer may not withhold payment of any invoice or other amount due to
    the Seller by reason of any right of set-off or counterclaim which the
    Buyer may have or allege to have for any reason whatsoever.
</p>
<p>
    <strong><u>14. Entire Agreement</u></strong>
    <strong></strong>
</p>
<p>
    These Conditions and any documents incorporating them or incorporated by
    them constitute the entire agreement and understanding between the parties.
</p>
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Conditions'),

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
