class Cart {
  int id;
  int product_id;
  String name;
  int qty;
  double price;
  String image_path;

  Cart({
    required this.id,
    required this.product_id,
    required this.name,
    required this.qty,
    required this.price,
    required this.image_path,
  });

  Cart.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        product_id = json['product_id'],
        name = json['name'],
        qty = json['qty'],
        price = double.parse(json['price']),
        image_path = json['image_path'];
}
