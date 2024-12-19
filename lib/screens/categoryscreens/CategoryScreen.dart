// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_big_shop/screens/product/ProductFilterByCategoryScreen.dart';
//
// import 'package:http/http.dart' as http;
//
// import '../models/Category.dart';
// import '../util/Constants.dart';
//
//
// class CategoryScreen extends StatefulWidget {
//
//   final String title;
//
//   const CategoryScreen({super.key, required this.title});
//
//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }
//
// class _CategoryScreenState extends State<CategoryScreen> {
//
//
//   late List<Category> categories = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     try {
//       final response = await http.get(
//           Uri.parse(Constants.BASE_URL + Constants.CATEGORY_ROUTE));
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body)['data'];
//
//         setState(() {
//           categories =
//               data.map((category) => Category.fromJson(category)).toList();
//         });
//       } else {
//         throw Exception('Failed to load categories ' + Constants.BASE_URL +
//             Constants.CATEGORY_ROUTE);
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   void navigateToProductScreen(Category selectedCategory) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProductFilterByCategoryScreen(title:selectedCategory.name, category:selectedCategory),
//       ),
//     );
//   }
//
//   Future<void> onRefresh() async {
//     await fetchData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               fetchData();
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: onRefresh,
//         child: categories.isEmpty
//             ? Center(child: CircularProgressIndicator())
//             : ListView.builder(
//           itemCount: categories.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               leading: Image.network(
//                 categories[index].image_path,
//                 height: 80,
//                 width: 80,
//                 fit: BoxFit.cover,
//               ),
//               title: Text(categories[index].name),
//               onTap: () {
//                 navigateToProductScreen(categories[index]);
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }






import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_big_shop/screens/product/ProductFilterByCategoryScreen.dart';
import 'package:http/http.dart' as http;
import '../../models/Category.dart';
import '../../util/Constants.dart';

class CategoryScreen extends StatefulWidget {
  final String title;

  const CategoryScreen({super.key, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
          Uri.parse(Constants.BASE_URL + Constants.CATEGORY_ROUTE));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          categories =
              data.map((category) => Category.fromJson(category)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories ' + Constants.BASE_URL +
            Constants.CATEGORY_ROUTE);
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToProductScreen(Category selectedCategory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFilterByCategoryScreen(
            title: selectedCategory.name,
            category: selectedCategory
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    setState(() {
      isLoading = true;
    });
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
              onRefresh();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : categories.isEmpty
            ? Center(child: Text('No categories found'))
            : GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                navigateToProductScreen(categories[index]);
              },
              child: Hero(
                tag: 'category_${categories[index].id}',
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            child: Image.network(
                              categories[index].image_path,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            categories[index].name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
