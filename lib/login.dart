import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:int/HomeScreen.dart';
import 'package:int/forget_password.dart';
import 'package:int/globals.dart';
import 'package:int/models/user.dart';
import 'package:int/signup.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<String?> login(String email, String password) async {
  var url = Uri.parse('http://${server}:8000/users/login/');
  final response = await post(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }));
  Map data = json.decode(response.body);
  return data['token'];
}

Future<void> fetchMyProfile() async {
  var url = Uri.parse('http://${server}:8000/users/my_profile/');
  final response = await get(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token ${token}'
    },
  );
  Map<String, dynamic> data = json.decode(response.body);
  myProfile = User.fromJson(data);
}
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 60,),
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'), 
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 40,),
          // SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.blue.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade300,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: Colors.grey.shade200,
                            ))),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => forget_password()),
                      );
                    },
                    child: Center(
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(color: Colors.blue.shade300),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                // If the form is valid, display a Snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Processing Data')),
                );
                  token = await login(_emailController.text.trim(),
                        _passwordController.text.trim());
                  if (token != null) {
                    fetchMyProfile();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid email or password')),
                    );
                  }
              }
                      
                      
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomeScreen()),
                      // );
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => signup()),
                    );
                    },
                    child: Center(
                      child: Text(
                        "Create Account",
                        style: TextStyle(color: Colors.blue[300]),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
