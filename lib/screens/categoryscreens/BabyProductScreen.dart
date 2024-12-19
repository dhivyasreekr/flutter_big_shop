import 'package:flutter/material.dart';

class BabyProductScreen extends StatelessWidget {
  final String BabyProductScreenTitle;

  const BabyProductScreen({Key? key, required this.BabyProductScreenTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BabyProductScreen'),
      ),
      body: Center(
        child: Text(
          'Content for $Title',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
