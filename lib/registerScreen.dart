import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:role_based_access/loginScreen.dart';
import 'dart:convert';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<String> role = ['admin', 'doctor', 'patient', 'pharmacist', 'lab_technician'];
  String roleValue = 'admin';

  Future<void> signUpUser() async {
    final response = await http.post(
      Uri.parse('http://10.0.0.100:5000/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'email': emailController.text,
        'getPassword': passwordController.text,
        "role": roleValue
      }),
    );
print(response.statusCode);
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registered Successfully'),backgroundColor: Colors.green,));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to Register'),backgroundColor: Colors.red,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: PreferredSize(preferredSize: const Size.fromHeight(50),
        child: AppBar(title: const Text('SignUp'),
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
                controller: usernameController,
                decoration: const InputDecoration(
                    hintText: "User Name"
                ),
                keyboardType: TextInputType.text,
                validator: (name){
                  if(name!.isEmpty  )  // email filed jodi empty hoi and @ na thake tahole invalid message return korbe
                      {
                    return "Please enter a name";
                  }
                  else{
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20,),
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
                    // go to login page
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
                  },
                  child: const Text("Login",style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                  ),),
                ),
              ),
              DropdownMenu<String>(
                  initialSelection: roleValue,  // initially public toilet select
                  onSelected: (String? val){
                    // This is called when the user selects an item.
                    setState(() {
                      roleValue = val!;
                    });
                  },
                  dropdownMenuEntries: role.map<DropdownMenuEntry<String>>((String value){
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList()
              ),
              const SizedBox(height: 50,),
              ElevatedButton(onPressed: (){
                if(_key.currentState!.validate()){
                  //call signup user
                  signUpUser();
                }
              }, child: const Text('SignUp'))


            ],
          ),
        ),
      ),
    );
  }
}
