import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:role_based_access/registerScreen.dart';
import 'dart:convert';

import 'package:role_based_access/roleScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final response = await http.post(
      Uri.parse('http://10.0.0.100:5000/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Successfull'),backgroundColor: Colors.green,));
      final data = jsonDecode(response.body);
      // final role = data['role'];
      final token = data['token'];  // same as res.json({ token, role: user.role });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoleScreen(token: token,),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Failed'),backgroundColor: Colors.red,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: PreferredSize(preferredSize: const Size.fromHeight(50),
        child: AppBar(title: const Text('Login'),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 50,),
              const Text( 'Welcome Back!', style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600, color: Colors.black)),
              const Text('Fill the details to login to your account', style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              )),
              const SizedBox(height: 50,),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email"
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (email){
                  if(email!.isEmpty || !email.contains("@") )  // email filed jodi empty hoi and @ na thake tahole invalid message return korbe
                      {
                    return "Please enter a valid email";
                  }
                  else{
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                    hintText: "Password"
                ),
                keyboardType: TextInputType.text,
                validator: (password){
                  if(password!.isEmpty || password.length<6)  // email filed jodi empty hoi and @ na thake tahole invalid message return korbe
                      {

                    return "Please enter at least 6 digit password";
                  }
                  return null;
                },

              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  // Get.offAll use koresi jeno login page ba signup age theke back korle onno page a na jai karon login, signup page e jawar jonno already button deya ase
                  onTap: (){
                    // go to register page
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen(),));
                  },
                  child: const Text("Register",style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                  ),),
                ),
              ),
              const SizedBox(height: 50,),
              ElevatedButton(onPressed: (){
                if(_key.currentState!.validate()){
loginUser();
                }
              }, child: const Text('Login'))


            ],
          ),
        ),
      ),
    );
  }
}
