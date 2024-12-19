import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/Cart.dart';
import '../../services/CartProvider.dart';
import '../../util/Constants.dart';
import '../cart/CartDetailScreen.dart';

class CartScreen extends StatefulWidget {
  final String title;

  const CartScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Create Storage
  final storage = new FlutterSecureStorage();

  late List<Cart> carts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  double getGrandTotalPrice() {
    return carts.fold(0, (sum, item) => sum + (item.price * item.qty));
  }

  double getSubtotal(Cart row) {
    return row.price * row.qty;
  }

  Future<void> fetchData() async {
    try {
      dynamic token = await this.storage.read(key: 'token');
      print(token);

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      final response = await http.get(
          headers: headers,
          Uri.parse(Constants.BASE_URL + Constants.CART_ROUTE));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          carts = data.map((cart) => Cart.fromJson(cart)).toList();
        });
      } else {
        throw Exception(
            'Failed to load carts' + Constants.BASE_URL + Constants.CART_ROUTE);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void navigateToProductScreen(Cart selectedCart) {
    // Implement your navigation logic here
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CartDetailScreen(cart: selectedCart),
    //   ),
    // );
  }

  Future<void> increaseCartQuantity(int cartId, int qty) async {
    try {
      dynamic token = await this.storage.read(key: 'token');

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      final body = json.encode({
        'cart_id': cartId,
        // 'qty': qty
      });

      final response = await http.post(
        headers: headers,
        Uri.parse(Constants.BASE_URL + Constants.INCREASE_CART_QTY_ROUTE),
        body: body,
      );

      if (response.statusCode == 200) {
        fetchData();
      } else {
        throw Exception('Failed to update cart quantity');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> decreaseCartQuantity(int cartId, int qty) async {
    try {
      dynamic token = await this.storage.read(key: 'token');

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      final body = json.encode({
        'cart_id': cartId,
        // 'qty': qty
      });

      final response = await http.post(
        headers: headers,
        Uri.parse(Constants.BASE_URL + Constants.DECREASE_CART_QTY_ROUTE),
        body: body,
      );

      if (response.statusCode == 200) {
        fetchData();
      } else {
        throw Exception('Failed to update cart quantity');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildCartProduct(int index) {
    return GestureDetector(
      onLongPress: () async {
        Map cart = {
          'cart_id': carts[index].id.toString(),
          'product_name': carts[index].name,
        };
        await Provider.of<CartProvider>(context, listen: false)
            .removeFromCart(cart: cart, context: context);

        await fetchData();
      },
      child: ListTile(
        contentPadding: EdgeInsets.all(20.0),
        leading: Image(
          height: double.infinity,
          width: 100.0,
          image: NetworkImage(
            carts[index].image_path,
          ),
          fit: BoxFit.contain,
        ),
        title: Text(
          carts[index].name,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "\₹${carts[index].price.toString()} x ${carts[index].qty.toString()}",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (carts[index].qty > 1) {
                      decreaseCartQuantity(carts[index].id, carts[index].qty - 1);
                    }
                  },
                ),
                Text(carts[index].qty.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    increaseCartQuantity(carts[index].id, carts[index].qty + 1);
                  },
                ),
              ],
            ),
          ],
        ),
        trailing: Text(
          '\₹${getSubtotal(carts[index]).toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Shopping Cart (${carts.length})',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await Provider.of<CartProvider>(context, listen: false).clearCart();
              await fetchData();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: carts.isEmpty
            ? Center(child: Text("Your Cart is Empty"))
            : ListView.separated(
          itemCount: carts.length,
          itemBuilder: (context, index) {
            return _buildCartProduct(index);
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey[300],
            );
          },
        ),
      ),
      bottomSheet: carts.isEmpty
          ? null
          : Container(
        height: 80.0,
        color: Colors.orange,
        child: Center(
          child: Text(
            'PLACE ORDER (\₹${getGrandTotalPrice().toStringAsFixed(2)})',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


