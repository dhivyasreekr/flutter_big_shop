import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Product.dart';
import '../../services/CartProvider.dart';

class ProductDetailScreen extends StatefulWidget {

  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product.image_path,
              fit: BoxFit.fill,
            ),
            Text('ID: ${widget.product.id}'),
            Text('Name: ${widget.product.name}'),
            Text('Price: ${widget.product.price}'),
            Text('Brand: ${widget.product.brand}'),

            Text('Description: ${widget.product.description}'),
            Text('Qty: ${widget.product.qty}'),
            Text('Alert_stock: ${widget.product.alert_stock}'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add to cart functionality
                  // For example, you could call a method in your cart provider to add this product to the cart
                  // cartProvider.addToCart(product);
                  Map cart = {
                    'product_id' : widget.product.id.toString(),
                    'product_name': widget.product.name,
                  };
                  Provider.of<CartProvider>(context, listen: false).addToCart(cart: cart, context: context);

                },
                child: Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
