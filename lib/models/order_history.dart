
class OrderHistory {

  int order_id, total, subtotal;
  var address;
  var order_no, date, orderStatus, shipping,shipping_type,penlaty,cancle_reason;
  List products;
  OrderHistory({this.order_id, this.address, this.total, this.order_no, this.date,this.penlaty,
    this.shipping, this.subtotal, this.orderStatus, this.products,this.shipping_type,this.cancle_reason});

}