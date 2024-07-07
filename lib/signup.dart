import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:int/HomeScreen.dart';
import 'package:int/globals.dart';
import 'package:int/login.dart';
import 'package:int/models/user.dart';

class signup extends StatefulWidget {
  @override
  _signupState createState() => _signupState();

}

class _signupState extends State<signup> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
    final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _genderController = TextEditingController();

  Future<String?> signup(String email, String password, String firstName, String lastName, String gender) async {
  var url = Uri.parse('http://${server}:8000/users/signup/');
  final response = await post(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
      }));
  Map data = json.decode(response.body);
  return data['email'];
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
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'), 
                  fit: BoxFit.contain,
                ),
              ),
            ),
          // SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Signup",
                    style: TextStyle(
                      color: Colors.blue.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 30),
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
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: Colors.grey.shade200,
                            ))),
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "First Name",
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
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: Colors.grey.shade200,
                            ))),
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Last Name",
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
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: Colors.grey.shade200,
                            ))),
                            child: TextFormField(
                              controller: _genderController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Gender",
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
              
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                // If the form is valid, display a Snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Processing Data')),
                );
                  var email = await signup(_emailController.text.trim(),
                        _passwordController.text.trim(), _firstNameController.text.trim(), _lastNameController.text.trim(), _genderController.text.trim());
                  if (email != null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You have been registered successfully.')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => login()),
                    );
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid Information.')),
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
                          "signup",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => login()),
                    );
                    },
                    child: Center(
                      child: Text(
                        "Have an Account",
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
