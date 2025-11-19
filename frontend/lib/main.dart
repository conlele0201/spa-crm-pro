import 'package:flutter/material.dart';

void main() {
  runApp(const SpaCRMProApp());
}

class SpaCRMProApp extends StatelessWidget {
  const SpaCRMProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spa CRM Pro',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text(
            'Spa CRM Pro – Flutter Web Skeleton Loaded',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

