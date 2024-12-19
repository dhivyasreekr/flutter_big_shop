class Order {
  int id;
  String order_date;
  double total_amount;
  String customer_name;

  Order({
    required this.id,
    required this.order_date,
    required this.total_amount,
    required this.customer_name,
  });

  Order.fromJson(Map<String, dynamic> json)
      :
        id = json['id'],
        order_date = json['order_date'],
        total_amount = double.parse(json['total_amount']),
        customer_name = json['customer_name'];
}

// TODO Implement this library.