import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';


import '../services/auth.dart';
import 'categoryscreens/BabyProductScreen.dart';
import 'categoryscreens/BeverageScreen.dart';
import 'categoryscreens/FreshProduceScreen.dart';
import 'categoryscreens/FrozenFoodScreen.dart';
import 'categoryscreens/SnackScreen.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = FlutterSecureStorage();


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

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildBanner(),
            _buildCategorySection(),
            _buildFeaturedProductsSection(),
          ],
        ),
      ),
    );
  }
  Widget _buildBanner() {
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: Center(
        child: Text(
          'Banner Placeholder',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _buildCategoryItem('Baby Products', Icons.child_care),
                _buildCategoryItem('Beverages', Icons.liquor),
                _buildCategoryItem('Fresh Produce', Icons.store),
                _buildCategoryItem('Frozen Foods', Icons.icecream),
                _buildCategoryItem('Snacks', Icons.cookie),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCategoryItem(String title, IconData icon) {
    return GestureDetector(
      onTap: () =>  () {
        Widget screen;
        switch (title) {
          case 'Baby Products':
            screen = BabyProductScreen(BabyProductScreenTitle: 'Baby Products Screen');
            break;
          case 'Beverages':
            screen = BeveragesScreen(title: 'Beverages');
            break;
          case 'Fresh Produce':
            screen = FreshProduceScreen(title: 'Fresh Produce');
            break;
          case 'Frozen Foods':
            screen = FrozenFoodScreen(title: 'Frozen Foods');
            break;
          case 'Snacks':
            screen = SnackScreen(title: 'Snacks');
            break;
          default:
            screen = Scaffold(
              appBar: AppBar(title: Text('Unknown Category')),
              body: Center(child: Text('No screen defined for this category')),
            );
        }

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BabyProductScreen(BabyProductScreenTitle: 'BabyProduct Screen',)),
        );
      },


    child: Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            child: Icon(icon, size: 30),
          ),
          SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
     ),
    );
  }

  Widget _buildFeaturedProductsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Featured Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8, // Adjust the aspect ratio as per your preference
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _buildFeaturedProductItem();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProductItem() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'Product Image',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0), // Reduce the padding here
            child: Text(
              'Product Title',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '\$99.99',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
