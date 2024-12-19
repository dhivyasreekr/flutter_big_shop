import 'package:flutter/material.dart';
import 'package:flutter_big_shop/screens/product/ProductScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';


import '../services/auth.dart';
import 'categoryscreens/CategoryScreen.dart';
import 'HomeScreen.dart';

import 'OrderScreen.dart';
import 'SubCategoryScreen.dart';
import 'auth/LoginScreen.dart';


import 'auth/RegisterScreen.dart';
import 'brand/BrandScreen.dart';
import 'cart/CartScreen.dart';


class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();

  int currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(title: 'Home'),
    CategoryScreen(title: 'Category'),
    CartScreen(title: 'Cart'),
    // MyAccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    readToken();
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');

    if (token != null) {
      Provider.of<Auth>(context, listen: false).tryToken(token: token);
      print("read token");
      print(token);
    } else {
      print("Token is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Big Shop'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() => currentIndex = value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Account',
          ),
        ],
      ),
      drawer: Drawer(
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            if (!auth.authenticated) {
              return _buildDrawerLoggedOut();
            } else {
              return _buildDrawerLoggedIn(auth);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDrawerLoggedOut() {
    return ListView(
      children: [
        ListTile(
          title: Text('Login'),
          leading: Icon(Icons.login),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LoginScreen(title: 'Login Screen')),
            );
          },
        ),
        ListTile(
          title: Text('Register'),
          leading: Icon(Icons.app_registration),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RegisterScreen(title: 'Register')),
            );
          },
        ),
        ListTile(
          title: Text('Products'),
          leading: Icon(Icons.production_quantity_limits),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProductScreen(title: 'Product')),
            );
          },
        ),
        ListTile(
          title: Text('Brand'),
          leading: Icon(Icons.grade),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BrandScreen(title: 'Brand')),
            );
          },
        ),
        ListTile(
          title: Text('Category'),
          leading: Icon(Icons.category),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CategoryScreen(title: 'Category')),
            );
          },
        ),
        ListTile(
          title: Text('SubCategory'),
          leading: Icon(Icons.category),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SubCategoryScreen(title: 'SubCategory')),
            );
          },
        ),
      //   ListTile(
      //     title: Text('Order'),
      //     leading: Icon(Icons.shopping_cart),
      //     onTap: () {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(builder: (context) => OrderScreen(title: 'Order')),
      //       );
      //     },
      //   ),
      ],
    );
  }

  Widget _buildDrawerLoggedIn(Auth auth) {
    String avatar = auth.user?.avatar ?? '';
    String name = auth.user?.name ?? '';
    String email = auth.user?.email ?? '';

    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatar),
                radius: 30,
              ),
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                email,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),

        ListTile(
          title: Text('Product'),
          leading: Icon(Icons.shopping_cart),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProductScreen(title: 'Product')),
            );
          },
        ),
        ListTile(
          title: Text('Order'),
          leading: Icon(Icons.shopping_cart),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderScreen(title: 'Order')),
            );
          },
        ),
        ListTile(
          title: Text('Cart'),
          leading: Icon(Icons.shopping_cart),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CartScreen(title: 'Cart')),
            );
          },
        ),


        ListTile(
          title: Text('Logout'),
          leading: Icon(Icons.logout),
          onTap: () {
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ],
    );
  }
}


