import 'package:flutter/material.dart';
import 'package:flutter_big_shop/screens/HomePage.dart';
import 'package:flutter_big_shop/services/CartProvider.dart';
import 'package:flutter_big_shop/services/auth.dart';
import 'package:flutter_big_shop/services/CartProvider.dart';  // Import the CartProvider
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => CartProvider()),  // Add CartProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        routes: {
          '/home': (context) => HomePage(title: 'Home'),
        },
      ),
    );
  }
}
