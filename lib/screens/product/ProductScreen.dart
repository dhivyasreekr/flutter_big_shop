import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../models/Product.dart';
import '../../../util/Constants.dart';
import 'ProductDetailScreen.dart';

class ProductScreen extends StatefulWidget {
  final String title;

  const ProductScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final storage = FlutterSecureStorage();
  late List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      dynamic token = await storage.read(key: 'token');
      print(token);

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };
      final response = await http.get(
        Uri.parse(Constants.BASE_URL + Constants.PRODUCT_ROUTE),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          products = data.map((product) => Product.fromJson(product)).toList();
        });
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products')),
      );
    }
  }

  void navigateToProductScreen(Product selectedProduct) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: selectedProduct),
      ),
    );
  }

  Future<void> onRefresh() async {
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchData();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: products.isEmpty
            ? Center(child: CircularProgressIndicator())
            : _buildProductGridListUI(),
      ),
    );
  }

  Widget _buildProductGridListUI() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (100 / 150),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      scrollDirection: Axis.vertical,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            Image.network(product.image_path),
            Text(product.name),
            Text('\$${product.price.toString()}'),
          ],
        ),
      ),
    );
  }
}
