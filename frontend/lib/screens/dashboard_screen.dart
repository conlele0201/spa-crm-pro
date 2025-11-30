import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String userRole;

  const DashboardScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard ($userRole)'),
      ),
      body: const Center(
        child: Text('SPA CRM PRO Dashboard'),
      ),
    );
  }
}
