import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../models/Order.dart';
import '../../../util/Constants.dart';

import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {

  final String title;

  const OrderScreen({super.key, required this.title});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  // Create Storage
  final storage = new FlutterSecureStorage();

  late List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {

      dynamic token = await this.storage.read(key: 'token');
      print(token);

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      final response =
      await http.get(
          headers: headers,
          Uri.parse(Constants.BASE_URL + Constants.ORDER_ROUTE)
      );


      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          orders = data.map((row) => Order.fromJson(row)).toList(); // Corrected to Product.fromJson

        });
      } else {
        throw Exception('Failed to load orders' + response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void navigateToProductScreen(Order selectedOrder) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ProductFilterByBrandScreen(
    //       title: selectedOrder.name,
    //       brand: selectedOrder, // Adjusted argument name
    //     ),
    //   ),
    // );
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
        child: orders.isEmpty
            ? Center(child: Text("Your Order is Empty"))
            : ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(orders[index].order_date),
              onTap: () {
                navigateToProductScreen(orders[index]);
              },
            );
          },
        ),
      ),
    );
  }
}