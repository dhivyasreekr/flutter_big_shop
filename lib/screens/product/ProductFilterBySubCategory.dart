import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../models/Product.dart';

import 'package:http/http.dart' as http;

import '../../../util/Constants.dart';
import '../../models/SubCategory.dart';
import 'ProductDetailScreen.dart';

class ProductFilterBySubCategoryScreen extends StatefulWidget {

  final String title;

  final SubCategory subcategory;

  const ProductFilterBySubCategoryScreen({super.key, required this.title, required this.subcategory});

  @override
  State<ProductFilterBySubCategoryScreen> createState() => _ProductFilterBySubCategoryScreenState();
}

class _ProductFilterBySubCategoryScreenState extends State<ProductFilterBySubCategoryScreen> {
  late List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
      await http.get(Uri.parse(Constants.BASE_URL + Constants.PRODUCT_FILTER_BY_CATEGORY_ROUTE + widget.subcategory.id.toString()));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          products = data.map((product) => Product.fromJson(product)).toList(); // Corrected to Product.fromJson

        });
      } else {
        throw Exception(
            'Failed to load product' + Constants.BASE_URL + Constants.PRODUCT_FILTER_BY_CATEGORY_ROUTE + widget.subcategory.id.toString());
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void navigateToProductScreen(Product selectedProduct) {
    // Implement your navigation logic here
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
        title: Text(widget.subcategory.name),
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
            : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(products[index].name),
              onTap: () {
                navigateToProductScreen(products[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
