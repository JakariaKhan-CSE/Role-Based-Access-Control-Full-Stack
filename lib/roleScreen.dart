
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class RoleScreen extends StatefulWidget {
final String token;
String role ='null';
  RoleScreen({super.key, required this.token});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  Future<void> dashBoardUser() async {
    final response = await http.get(
      Uri.parse('http://10.0.0.100:5000/api/auth/dashboard'),
      headers: {'Content-Type': 'application/json',
      'Authorization': widget.token
      },

    );
    print(response.statusCode);
    setState(() {
      //   res.json({ token, role: user.role }); airokom thakle jsonDecode korte hobe
      widget.role = response.body;  // return res.send('Doctor'); airokom thakle jsonDecode kora lagbe na
    });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registered Successfully'),backgroundColor: Colors.green,));


    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to Register'),backgroundColor: Colors.red,));
    }
  }
  @override
  void initState() {
    dashBoardUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Text(widget.role, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
