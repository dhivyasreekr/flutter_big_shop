import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_big_shop/screens/product/ProductFilterBySubCategory.dart';

import 'package:http/http.dart' as http;

import '../models/SubCategory.dart';
import '../util/Constants.dart';


class SubCategoryScreen extends StatefulWidget {

  final String title;

  const SubCategoryScreen({super.key, required this.title});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {


  late List<SubCategory> subcategories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
          Uri.parse(Constants.BASE_URL + Constants.SUB_CATEGORY_ROUTE));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          subcategories =
              data.map((category) => SubCategory.fromJson(category)).toList();
        });
      } else {
        throw Exception('Failed to load subcategories ' + Constants.BASE_URL +
            Constants.SUB_CATEGORY_ROUTE);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void navigateToProductScreen(SubCategory selectedSubCategory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFilterBySubCategoryScreen(title:selectedSubCategory.name, subcategory:selectedSubCategory),
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
        child: subcategories.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: subcategories.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.network(
                subcategories[index].image_path,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
              title: Text(subcategories[index].name),
              onTap: () {
                navigateToProductScreen(subcategories[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
