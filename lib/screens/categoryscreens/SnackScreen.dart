import 'package:flutter/material.dart';

class SnackScreen extends StatelessWidget {
  final String title;

  const SnackScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Content for $title',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}