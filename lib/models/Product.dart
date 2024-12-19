class Product {
  int id;
  String name;
  String description;
  double price; // Change to double
  // String category; // Make category nullable since it can be null in JSON
  String brand;
  String image_path;
  int qty;
  int alert_stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    // required this.category,
    required this.brand,
    required this.image_path,
    required this.qty,
    required this.alert_stock,
  });

  Product.fromJson(Map<String, dynamic> json):
        id = json['id'],
        name = json['name'],
        description = json['description'],
        price = double.parse(json['price']), // Convert string to double
        // category = json['category'],
        brand = json['brand'],
        image_path = json['image_path'],
        qty = json['qty'],
        alert_stock = json['alert_stock'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price.toString(), // Convert double to string
      // 'category': category,
      'brand': brand,
      'image_path': image_path,
      'qty': qty,
      'alert_stock': alert_stock,
    };
  }
}
