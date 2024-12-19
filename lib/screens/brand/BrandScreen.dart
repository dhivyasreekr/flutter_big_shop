import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../models/Brand.dart'; // Make sure this import is correct
import '../../../util/Constants.dart';
import '../product/ProductFilterByBrandScreen.dart';


class BrandScreen extends StatefulWidget {
  final String title;

  const BrandScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  late List<Brand> brands = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.BRAND_ROUTE));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          brands = data.map((brand) => Brand.fromJson(brand)).toList();
        });
      } else {
        throw Exception('Failed to load brands');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void navigateToProductScreen(Brand selectedBrand) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFilterByBrandScreen(
          title: selectedBrand.name,
          brand: selectedBrand, // Adjusted argument name
        ),
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
            onPressed: fetchData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: brands.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: brands.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.network(
                brands[index].image_path,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
              title: Text(brands[index].name),
              onTap: () {
                navigateToProductScreen(brands[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
