import 'package:flutter/material.dart';

class RoleScreen extends StatelessWidget {
  final String role;

  RoleScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: Text(role, style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
